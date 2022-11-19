import 'package:flutter/material.dart';

import 'routes.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            Text(
              "This is screen one",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.screenTwo),
              child: const Text("Go To Screen Two"),
            )
            //
          ],
        ),
      ),
    );
  }
}
