import 'dart:math';

import 'package:flutter/material.dart';

class CircularStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double strokeWidth;
  final double gapSize;
  final bool removeDefaultCenterText;
  final String centerText;
  final TextStyle? centerTextStyle;
  final Color? completedStepsColor;
  final Color? stepColor;

  const CircularStepper({
    this.totalSteps = 5,
    this.currentStep = 1,
    this.strokeWidth = 2.0,
    this.gapSize = 0.00,
    this.removeDefaultCenterText = false,
    this.centerText = '',
    this.centerTextStyle,
    this.completedStepsColor,
    this.stepColor,
    super.key,
  }) : assert(currentStep < totalSteps,
            'currentStep:$currentStep > totalSteps:$totalSteps');

  @override
  Widget build(BuildContext context) {
    final Widget centerWidget = removeDefaultCenterText
        ? centerText.isEmpty
            ? const SizedBox.shrink()
            : Center(
                child: Text(centerText,
                    style: centerTextStyle ??
                        Theme.of(context).textTheme.bodySmall),
              )
        : Center(
            child: Text("$currentStep/$totalSteps",
                style:
                    centerTextStyle ?? Theme.of(context).textTheme.bodySmall),
          );

    return CustomPaint(
        painter: CirclePainter(
            strokeCount: totalSteps,
            userStrokeCount: currentStep,
            strokeWidth: strokeWidth,
            gapSize: gapSize,
            completedStepsColor:
                completedStepsColor ?? Theme.of(context).colorScheme.primary,
            stepColor: stepColor ?? Theme.of(context).colorScheme.shadow),
        child: centerWidget);
  }
}

class CirclePainter extends CustomPainter {
  final int strokeCount;
  final int userStrokeCount;
  final double strokeWidth;
  final double gapSize;
  final Color completedStepsColor;
  final Color stepColor;

  CirclePainter({
    required this.strokeCount,
    required this.userStrokeCount,
    required this.strokeWidth,
    required this.gapSize,
    required this.completedStepsColor,
    required this.stepColor,
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
        ..color = i < userStrokeCount ? completedStepsColor : stepColor
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
