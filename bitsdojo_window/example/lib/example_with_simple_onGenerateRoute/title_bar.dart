import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class ExamplWithOnGenerateRouteTitleBar extends StatelessWidget {
  const ExamplWithOnGenerateRouteTitleBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //
          WindowTitleBarBox(
            child: MoveWindow(
              child: Container(
                color: Colors.deepOrange, // Enter any color you prefer
                child: Row(
                  children: const [
                    //
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "App With Simple OnGenerateRoute Navigation",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Spacer(),

                    ActionButtons()
                    //
                  ],
                ),
              ),
            ),
          ),

          Flexible(child: child)
          //
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //
        MinimizeWindowButton(
          animate: false,
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        MaximizeWindowButton(
          animate: false,
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        CloseWindowButton(
          animate: false,
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        //
      ],
    );
  }
}
