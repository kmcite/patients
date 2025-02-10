import '../main.dart';

class BorderRadiusModifier extends UI {
  const BorderRadiusModifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Border Radius'.text(textScaleFactor: 1.5).pad(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: borderRadius().toStringAsFixed(1),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  double? newValue = double.tryParse(value);
                  if (newValue != null && newValue >= 0 && newValue <= 35) {
                    borderRadius(newValue);
                  }
                },
                decoration: InputDecoration(
                  suffixText: 'px',
                  labelText: 'Border Radius',
                ),
              ),
            ),
            SizedBox(width: 16),
            Text('${borderRadius().toStringAsFixed(1)} px'),
          ],
        ),
      ],
    ).pad();
  }
}
