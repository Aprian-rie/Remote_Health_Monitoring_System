import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter{
  double value;
  bool isTemp;

  CircleProgress(this.value, this.isTemp);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size){
    int maximumValue = isTemp ? 50 : 200; // Temp's Max is 50 bpm is 200

    Paint outerCircle = Paint()
    ..strokeWidth = 14
    ..color = Colors.grey
    ..style = PaintingStyle.stroke;

    Paint tempArc = Paint()
      ..strokeWidth = 14
      ..color = Color(0xff006989)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint bpmArc = Paint()
      ..strokeWidth = 14
      ..color = Color(0xff615EFC)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2, size.height /2) - 14;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / maximumValue);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2,
        angle, false, isTemp? tempArc : bpmArc);

  }

}
