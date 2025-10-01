import 'package:flutter/material.dart';
import 'package:waiting_room_app/waiting_room_card.dart'; // Import your card widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiting Room', // Title as in the TP
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Waiting Room'), // AppBar as in the TP
        ),
        body: const Center(
          child: WaitingRoomCard(name: 'maram bouagina'), // Using your WaitingRoomCard
        ),
      ),
    );
  }
}
