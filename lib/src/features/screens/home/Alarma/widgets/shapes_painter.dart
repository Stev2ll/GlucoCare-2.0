import 'dart:math';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:vector_math/vector_math_64.dart' as Vector;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var angle = Vector.radians(-90);

    final double r = sqrt(size.width * size.width + size.height * size.height) / 2;
    final alpha = atan(size.height / size.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = size.width / 2 - shiftX;
    final translateY = size.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);

    DateTime now = DateTime.now();
    final paint = Paint();
    var center = Offset(size.width / 2, size.height / 2);
    paint.color = Colors.white;

    // Reduce the size of the circle further
    double circleRadius = (size.width / 6) - 5;
    canvas.drawCircle(center, circleRadius, paint);
    paint.strokeCap = StrokeCap.round;

    // Seconds line
    final secondsP1 = center;
    double secondDegree = 360 / 60 * now.second;
    double x = (size.width / 2) + (circleRadius - 10) * cos(Vector.radians(secondDegree));
    double y = (size.height / 2) + (circleRadius - 10) * sin(Vector.radians(secondDegree));
    final secondsP2 = Offset(x, y);

    paint.color = const Color(0xff65D1BA);
    paint.strokeWidth = 2;
    canvas.drawLine(secondsP1, secondsP2, paint);

    // Minutes line
    final minutesP1 = center;
    double minuteDegree = 360 / 60 * now.minute;
    x = (size.width / 2) + (circleRadius - 20) * cos(Vector.radians(minuteDegree));
    y = (size.height / 2) + (circleRadius - 20) * sin(Vector.radians(minuteDegree));
    final minutesP2 = Offset(x, y);

    paint.color = const Color(0xff354569);
    paint.strokeWidth = 3;
    canvas.drawLine(minutesP1, minutesP2, paint);

    // Hours line
    final p1 = center;
    double hourseDegree = 360 / 12 * (now.hour - 12);
    hourseDegree += 30 / 60 * now.minute;
    x = (size.width / 2) + (circleRadius - 30) * cos(Vector.radians(hourseDegree));
    y = (size.height / 2) + (circleRadius - 30) * sin(Vector.radians(hourseDegree));
    final p2 = Offset(x, y);

    paint.color = const Color(0xff354569);
    paint.strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);

    // External lines
    for (int i = 0; i < 60; i++) {
      double minute = 360 / 60 * i;
      paint.color = (i % 5 == 0) ? const Color(0xff65D1BA) : const Color.fromARGB(255, 8, 8, 8);
      paint.strokeWidth = (i % 5 == 0) ? 4 : 1;

      int distance = (i % 5 == 0) ? 5 : 10;
      double x1 = (size.width / 2) + (circleRadius + distance) * cos(Vector.radians(minute));
      double y1 = (size.height / 2) + (circleRadius + distance) * sin(Vector.radians(minute));
      final p1 = Offset(x1, y1);

      double x2 = (size.width / 2) + (circleRadius + 10) * cos(Vector.radians(minute));
      double y2 = (size.height / 2) + (circleRadius + 10) * sin(Vector.radians(minute));
      final p2 = Offset(x2, y2);

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
