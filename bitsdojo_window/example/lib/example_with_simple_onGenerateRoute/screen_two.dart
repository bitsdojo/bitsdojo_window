import 'package:flutter/material.dart';

import 'routes.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            Text(
              "This is screen two",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.screenThree),
              child: const Text("Go To Screen Three"),
            )
            //
          ],
        ),
      ),
    );
  }
}
