import 'dart:math';

import 'package:flutter/material.dart';

class CircularStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double strokeWidth;
  final double gapSize;
  final Widget? widget;
  final String titleText;
  final TextStyle? titleTextStyle;
  final bool needSubTitle;
  final String subTitleText;
  final TextStyle? subTitleTextStyle;
  final bool removeDefaultCenterText;
  final String centerText;
  final TextStyle? centerTextStyle;

  const CircularStepper({
    this.totalSteps = 5,
    this.currentStep = 1,
    this.strokeWidth = 2.0,
    this.gapSize = 0.00,
    this.widget,
    this.titleText = '',
    this.titleTextStyle,
    this.needSubTitle = false,
    this.subTitleText = '',
    this.subTitleTextStyle,
    this.removeDefaultCenterText = false,
    this.centerText = '',
    this.centerTextStyle,
    super.key,
  }) : assert(currentStep < totalSteps,
            'currentStep:$currentStep > totalSteps:$totalSteps');

  @override
  Widget build(BuildContext context) {
    final Widget centerWidget = removeDefaultCenterText
        ? centerText.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Text(centerText,
                      style: centerTextStyle ??
                          Theme.of(context).textTheme.bodySmall),
                ))
        : SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: Text("$currentStep/$totalSteps",
                  style:
                      centerTextStyle ?? Theme.of(context).textTheme.bodySmall),
            ));

    return Row(
      children: [
        CustomPaint(
            painter: CirclePainter(
              strokeCount: totalSteps,
              userStrokeCount: currentStep,
              strokeWidth: strokeWidth,
              gapSize: gapSize,
            ),
            child: centerWidget),
        const SizedBox(width: 16),
        widget ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style:
                      titleTextStyle ?? Theme.of(context).textTheme.bodyLarge,
                ),
                if (needSubTitle)
                  Text(subTitleText,
                      style: subTitleTextStyle ??
                          Theme.of(context).textTheme.bodySmall)
              ],
            )
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final int strokeCount;
  final int userStrokeCount;
  final double strokeWidth;
  final double gapSize;

  CirclePainter({
    required this.strokeCount,
    required this.userStrokeCount,
    required this.strokeWidth,
    required this.gapSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double gapAngle = gapSize * (2 * pi / strokeCount);
    final double strokeAngle =
        (2 * pi - gapAngle * (strokeCount)) / strokeCount;
    for (int i = 0; i < strokeCount; i++) {
      final Paint paint = Paint()
        ..color =
            i < userStrokeCount ? Colors.blueAccent : const Color(0xffE8ECF3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      final double startAngle = -pi / 2 +
          i * (strokeAngle + gapAngle); // Start from the top right corner
      final Path path = Path()
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          strokeAngle,
          false,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
