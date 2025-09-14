import 'package:flutter/material.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/patients/patient_tile_2.dart';
import 'package:patients/utils/architecture.dart';

class SearchBloc extends Bloc {
  late final PatientsRepository patientsRepository;
  final searchController = TextEditingController();
  List<Patient> searchResults = [];

  @override
  void initState() {
    patientsRepository = watch<PatientsRepository>();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      searchResults = [];
    } else {
      final allPatients = patientsRepository.items.data ?? [];
      searchResults = allPatients.where((patient) {
        return patient.name.toLowerCase().contains(query) ||
            patient.email.toLowerCase().contains(query) ||
            (patient.contact.target?.mnp.contains(query) == true);
      }).toList();
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
  SearchBloc createBloc() => SearchBloc();

  @override
  Widget build(BuildContext context, SearchBloc bloc) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: bloc.searchController,
              decoration: const InputDecoration(
                labelText: 'Search patients...',
                hintText: 'Enter name, email, or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: bloc.searchResults.isEmpty
                ? Center(
                    child: Text(
                      bloc.searchController.text.isEmpty
                          ? 'Enter search terms to find patients'
                          : 'No patients found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: bloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return PatientTile(patient: bloc.searchResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
