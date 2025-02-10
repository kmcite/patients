import '../main.dart';

class RosterPage extends UI {
  const RosterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text(
          'ROSTER',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: materialColor(),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            child: Text(
              "${dutyHoursCalculator.calculateTotalDutyHours().inHours} Hours",
              textScaleFactor: 3,
              style: TextStyle(
                color: materialColor()[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).pad(),
          ).pad(),
          const RosterTable(),
        ],
      ),
    );
  }
}
