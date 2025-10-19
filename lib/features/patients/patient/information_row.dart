import 'package:flutter/material.dart';

class InformationRow extends StatelessWidget {
  const InformationRow({
    super.key,
    required this.label,
    required this.value,
    this.fallback = '—',
  });

  final String label;
  final String? value;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : fallback,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
