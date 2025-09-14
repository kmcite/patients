import 'package:flutter/material.dart';

class TableCellBuilder extends StatelessWidget {
  const TableCellBuilder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
