import 'package:flutter/material.dart';

import 'routes.dart';

class ScreenThree extends StatefulWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            Text(
              "This is screen three",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.screenOne),
              child: const Text("Go Back To Screen One"),
            )
            //
          ],
        ),
      ),
    );
  }
}
