import 'package:flutter/material.dart';
import 'circleProgress.dart';

class HomeTab extends StatelessWidget {
  final bool isLoading;
  final Animation<double> tempAnimation;
  final Animation<double> bpmAnimation;

  const HomeTab({
    Key? key,
    required this.isLoading,
    required this.tempAnimation,
    required this.bpmAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const Text(
        'Loading....',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomPaint(
            foregroundPainter: CircleProgress(tempAnimation.value, true),
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Temperature'),
                    Text(
                      '${tempAnimation.value.toInt()}',
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '°C',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomPaint(
            foregroundPainter: CircleProgress(bpmAnimation.value, false),
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Beats-Per-Minute'),
                    Text(
                      '${bpmAnimation.value.toInt()}',
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'BPM',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
