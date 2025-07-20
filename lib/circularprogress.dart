library circularprogress;

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class circularprogress extends StatefulWidget {
  final double size;
  final double height;
  final double width;
  const circularprogress({Key? key,required this.size,required this.height,required this.width}) : super(key: key);

  @override
  State<circularprogress> createState() => _ProgressWithIconState();
}

class _ProgressWithIconState extends State<circularprogress> {
  final int totalSteps = 8;
  int currentStep = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startProgressAnimation();
  }

  void startProgressAnimation() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        currentStep = (currentStep % totalSteps) + 1;
      });
    });
  }
  Color _getStepColor(int index) {
    int diff = (currentStep - index) % totalSteps;
    if (diff == 0) return Colors.grey.shade800;   // الأغمق (النشط)
    if (diff == 1) return Colors.grey.shade600;   // أقل غمقًا
    if (diff == 2) return Colors.grey.shade400;   // أفتح
    return Colors.grey.shade300;                  // الباقي
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double distanceFromCenter = widget.size ;
     double pointerWidth = widget.width;
     double pointerHeight = widget.height;
    //const double centerCircleSize = 20;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: distanceFromCenter * 2 + pointerWidth,
          height: distanceFromCenter * 2 + pointerWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [


              ...List.generate(totalSteps, (index) {
                final double angle = (2 * math.pi / totalSteps) * index;
                final double dx = distanceFromCenter * math.cos(angle);
                final double dy = distanceFromCenter * math.sin(angle);

                return Positioned(
                  left: distanceFromCenter + dx,
                  top: distanceFromCenter + dy,
                  child: Transform.rotate(
                    angle: angle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: pointerWidth,
                      height: pointerHeight,
                      decoration: BoxDecoration(
                        color: _getStepColor(index),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
