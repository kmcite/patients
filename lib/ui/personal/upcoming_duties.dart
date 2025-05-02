import '../../main.dart';

class UpcomingDuties extends UI {
  const UpcomingDuties({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final entry = upcomingDutyFinder.findNextRosterEntry(
      now,
      dutiesRepository.getAll(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Personal Roster',
          ),
          if (dutiesRepository.getAll().isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Please setup your personal roster to see your upcoming duty.',
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            const SizedBox(height: 16),
            Text(
              'Upcoming Duty',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(borderRadius()),
                    ),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                    width: 1,
                    // color: materialColor().withOpacity(0.5),
                    // borderRadius: BorderRadius.circular(borderRadius()),
                  ),
                  children: [
                    _buildTableRow(
                      '  DAY  ',
                      entry?.dayType().name.toUpperCase() ?? '-',
                    ),
                    _buildTableRow(
                      '  SHIFT  ',
                      entry?.shiftType().name.toUpperCase() ?? '-',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCellBuilder(
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TableCellBuilder(
          child: Text(value),
        ),
      ],
    );
  }
}
