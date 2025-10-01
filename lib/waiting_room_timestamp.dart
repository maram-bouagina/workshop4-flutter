import 'package:flutter/material.dart';

class WaitingRoomTimestamp extends StatelessWidget {
  const WaitingRoomTimestamp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Text(
      'Current time: ${now.hour}:${now.minute}:${now.second}',
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}
