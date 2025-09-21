import 'package:flutter/material.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/patients/edit_patient.dart';
import 'package:patients/utils/architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchBloc extends Bloc<SearchPage> {
  late final patientsRepository = watch<PatientsRepository>();
  final searchController = TextEditingController();
  List<Patient> searchResults = [];

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      searchResults = [];
    } else {
      final allPatients = patientsRepository.items.data ?? [];
      searchResults = allPatients.where(
        (patient) {
          return patient.name.toLowerCase().contains(query) ||
              patient.email.toLowerCase().contains(query) ||
              (patient.contact.target?.mnp.contains(query) == true);
        },
      ).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class SearchPage extends Feature<SearchBloc> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                labelText: 'Search patients...',
                hintText: 'Enter name, email, or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: controller.searchResults.isEmpty
                ? Center(
                    child: Text(
                      controller.searchController.text.isEmpty
                          ? 'Enter search terms to find patients'
                          : 'No patients found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      return EditPatientView(
                          patient: controller.searchResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
