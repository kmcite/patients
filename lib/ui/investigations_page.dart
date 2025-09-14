import 'package:flutter/material.dart';
import 'package:patients/domain/api/investigations.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/models/investigation.dart';
import 'package:patients/utils/architecture.dart';

class InvestigationsPageBloc extends Bloc {
  late final InvestigationsRepository investigationsRepository;
  bool isEditing = false;

  @override
  void initState() {
    investigationsRepository = watch<InvestigationsRepository>();
  }

  List<Investigation> get investigations =>
      investigationsRepository.investigations.hasData
          ? investigationsRepository.investigations.data!
          : [];

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void addInvestigation() {
    final investigation = Investigation()
      ..name = 'New Investigation'
      ..description = 'Investigation description'
      ..price = 200.0
      ..category = 'General';

    investigationsRepository.addInvestigation(investigation);
  }

  void removeInvestigation(Investigation investigation) {
    investigationsRepository.removeInvestigation(investigation);
  }
}

class InvestigationsPage extends Feature<InvestigationsPageBloc> {
  const InvestigationsPage({super.key});

  @override
  InvestigationsPageBloc createBloc() => InvestigationsPageBloc();

  @override
  Widget build(BuildContext context, InvestigationsPageBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navigator.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(bloc.isEditing ? Icons.check : Icons.edit),
            onPressed: bloc.toggleEditing,
          ),
        ],
      ),
      body: bloc.investigationsRepository.investigations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error loading investigations: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => bloc.investigationsRepository.loadAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (investigations) {
          if (investigations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No investigations yet',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first investigation to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: bloc.addInvestigation,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Investigation'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: investigations.length,
            itemBuilder: (context, index) {
              final investigation = investigations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.science,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    investigation.name.isNotEmpty
                        ? investigation.name
                        : 'Unnamed Investigation',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (investigation.category.isNotEmpty)
                        Text('Category: ${investigation.category}'),
                      Text('Price: ${investigation.formattedPrice}'),
                      if (investigation.description.isNotEmpty)
                        Text(
                          investigation.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: bloc.isEditing
                      ? IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: () =>
                              bloc.removeInvestigation(investigation),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: bloc.isEditing
                      ? null
                      : () {
                          // TODO: Navigate to investigation details
                        },
                ),
              );
            },
          );
        },
        empty: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.science_outlined,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              const Text('No investigations found'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: bloc.addInvestigation,
                icon: const Icon(Icons.add),
                label: const Text('Add Investigation'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.addInvestigation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
