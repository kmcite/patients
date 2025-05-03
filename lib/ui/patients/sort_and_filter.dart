import 'package:forui/forui.dart';
import 'package:patients/main.dart';

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

class SortAndFilter extends UI {
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
    return Column(
      children: [
        Row(
          children: [
            FAvatar.raw(
              child: 'F'.text(),
            ).pad(all: 4),
            ...FilterPatients.values.map(
              (eachfilter) {
                return FBadge(
                  label: Text(
                    eachfilter
                        .toString()
                        .split('.')
                        .last
                        .replaceAll('last', 'Last ')
                        .replaceAll('today', 'Today\'s ')
                        .replaceAll('all', 'All'),
                  ),
                  style: filter == eachfilter
                      ? FBadgeStyle.primary
                      : FBadgeStyle.secondary,
                  // onSelected: (value) {
                  //   onFilterChanged?.call(eachfilter);
                  // },
                ).pad(all: 4);
              },
            )
          ],
        ),
        Row(
          children: [
            FAvatar.raw(
              child: 'S'.text(),
            ).pad(all: 4),
            ...SortPatients.values.map(
              (eachfilter) {
                return FBadge(
                  label: Text(
                    eachfilter.description,
                  ),
                  style: sort == eachfilter
                      ? FBadgeStyle.primary
                      : FBadgeStyle.secondary,
                  // onSelected: (value) {
                  //   onSortChanged?.call(eachfilter);
                  // },
                ).pad(all: 4);
              },
            )
          ],
        ),
      ],
    );
  }
}
