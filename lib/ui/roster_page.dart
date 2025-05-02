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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor: materialColor(),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            "${dutyHoursCalculator.calculateTotalDutyHours().inHours} Hours",
            textScaleFactor: 3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).pad().pad(),
          RosterTable(),
        ],
      ),
    );
  }
}
