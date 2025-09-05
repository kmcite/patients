// import 'dart:async';

// import 'package:forui/forui.dart';
// import 'package:patients/domain/api/navigator.dart';

// import '../../main.dart';

// class _DutyRoster extends Bloc<void, int> {
//   StreamSubscription? _subscription;
//   _DutyRoster() {
//     _subscription = dutiesRepository.watch().listen(
//       (duties) {
//         emit(initialState);
//       },
//     );
//   }
//   @override
//   int get initialState => dutyHoursCalculator.calculateTotalDutyHours().inHours;
//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
// }

// late _DutyRoster _dutyRoster;

// class DutyRoster extends UI {
//   const DutyRoster({super.key});
//   @override
//   void didMountWidget(BuildContext context) {
//     super.didMountWidget(context);
//     _dutyRoster = _DutyRoster();
//   }

//   @override
//   void didUnmountWidget() {
//     _dutyRoster.dispose();
//     super.didUnmountWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader.nested(
//         prefixes: [
//           FButton.icon(
//             onPress: navigator.back,
//             child: Icon(FIcons.x),
//           ),
//         ],
//         title: const Text(
//           'ROSTER',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       child: ListView(
//         physics: const BouncingScrollPhysics(),
//         children: [
//           Text(
//             "${_dutyRoster()} Hours",
//             textScaleFactor: 3,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ).pad().pad(),
//           RosterTable(),
//         ],
//       ),
//     );
//   }
// }
