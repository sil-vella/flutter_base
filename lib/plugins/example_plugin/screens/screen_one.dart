// Example screen for the route
import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example Plugin Screen"),
      ),
      body: const Center(
        child: Text("Welcome to the Example Plugin Screen!"),
      ),
    );
  }
}