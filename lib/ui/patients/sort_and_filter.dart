import 'package:flutter/material.dart';

enum FilterPatients {
  all,
  today,
  last10,
}

enum SortPatients {
  date,
  name;

  String get description {
    return switch (this) {
      SortPatients.date => 'By date',
      SortPatients.name => 'By name',
    };
  }
}

class SortAndFilter extends StatelessWidget {
  final SortPatients sort;
  final FilterPatients filter;
  final void Function(SortPatients)? onSortChanged;
  final void Function(FilterPatients)? onFilterChanged;

  const SortAndFilter({
    super.key,
    this.sort = SortPatients.name,
    this.filter = FilterPatients.all,
    this.onSortChanged,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort & Filter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Sort Options
            Text('Sort by:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SortPatients.values.map((sortOption) {
                return ChoiceChip(
                  label: Text(sortOption.description),
                  selected: sort == sortOption,
                  onSelected: (selected) {
                    if (selected) onSortChanged?.call(sortOption);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Filter Options
            Text('Filter:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: FilterPatients.values.map((filterOption) {
                String label = switch (filterOption) {
                  FilterPatients.all => 'All Patients',
                  FilterPatients.today => 'Today',
                  FilterPatients.last10 => 'Last 10',
                };

                return ChoiceChip(
                  label: Text(label),
                  selected: filter == filterOption,
                  onSelected: (selected) {
                    if (selected) onFilterChanged?.call(filterOption);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
