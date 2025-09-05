// import 'dart:async';

// import 'package:forui/forui.dart';

// import '../../main.dart';
// import '../../domain/models/duty.dart';

// typedef RosterTableState = ({List<Duty> duties});

// class RosterEvent {}

// class PutRosterEvent extends RosterEvent {
//   final Duty duty;
//   PutRosterEvent(this.duty);
// }

// class RemoveRosterEvent extends RosterEvent {
//   final int id;
//   RemoveRosterEvent(this.id);
// }

// class _RosterTable extends Bloc<void, RosterTableState> {
//   _RosterTable() {
//     on<PutRosterEvent>(
//       (event) => dutiesRepository(event.duty),
//     );
//     on<RemoveRosterEvent>(
//       (event) => dutiesRepository.remove(event.id),
//     );
//     _dutiesSubscription = dutiesRepository.watch().listen(
//       (duties) {
//         emit(
//           (duties: duties),
//         );
//       },
//     );
//   }
//   StreamSubscription<List<Duty>>? _dutiesSubscription;
//   @override
//   void dispose() {
//     _dutiesSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   get initialState => (duties: dutiesRepository());
// }

// late _RosterTable _rosterTable;

// class RosterTable extends UI {
//   const RosterTable({super.key});
//   @override
//   void didMountWidget(BuildContext context) {
//     super.didMountWidget(context);
//     _rosterTable = _RosterTable();
//   }

//   @override
//   void didUnmountWidget() {
//     _rosterTable.dispose();
//     super.didUnmountWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder.all(width: 2),
//       children: [
//         TableRow(
//           children: [
//             TableCellBuilder(child: 'Day\\Shift'.text(textScaleFactor: .8)),
//             TableCellBuilder(child: 'Morning'.text(textScaleFactor: .8)),
//             TableCellBuilder(child: 'Evening'.text(textScaleFactor: .8)),
//             TableCellBuilder(child: 'Night'.text(textScaleFactor: .8)),
//           ],
//         ),
//         ...DayType.values.map(
//           (day) => TableRow(
//             children: [
//               TableCellBuilder(
//                 child: day.name.text(
//                   textScaleFactor: .75,
//                 ),
//               ),
//               ...ShiftType.values.map(
//                 (shift) => TableCellBuilder(
//                   child: FSwitch(
//                     value: _rosterTable().duties.any(
//                       (entry) {
//                         return entry.dayType() == day &&
//                             entry.shiftType() == shift;
//                       },
//                     ),
//                     onChange: (value) {
//                       try {
//                         final entry = dutiesRepository.getAll().firstWhere(
//                           (eachRosterEntry) {
//                             return eachRosterEntry.dayType() == day &&
//                                 eachRosterEntry.shiftType() == shift;
//                           },
//                         );
//                         _rosterTable(
//                           RemoveRosterEvent(entry.id),
//                         );
//                       } catch (e) {
//                         _rosterTable(
//                           PutRosterEvent(
//                             Duty()
//                               ..shiftType(shift)
//                               ..dayType(day),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ).pad();
//   }
// }
