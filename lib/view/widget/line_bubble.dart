import 'dart:math' as math;

import 'package:flutter/material.dart';

class LineBubbleNipPainter extends CustomPainter {
  LineBubbleNipPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.green;
    paint.strokeWidth = 1.0;
    //paint.style = PaintingStyle.fill;

    final Path path = Path();
    path.relativeQuadraticBezierTo(20.0, 0.0, 20.0, -20.0);
    path.relativeQuadraticBezierTo(-10.0, 10.0, -20.0, 10.0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LineBubbleNipPainter oldDelegate) {
    return false;
  }
}

class LineBubble extends StatelessWidget {
  const LineBubble({ Key key, this.child, this.hasNip = true}) : super(key: key);

  final Widget child;
  final bool hasNip;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();
    if (hasNip) {
      widgets.add(Positioned(
        child: CustomPaint(
            painter: LineBubbleNipPainter()
        ),
        top: 17.0,
        right: 12.0,
      ));
    }
    widgets.add(ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green
          ),
          child: child
        )
    ));
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: widgets,
    );

  }
}