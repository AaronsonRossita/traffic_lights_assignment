import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:traffic_lights_assignment/enums.dart';
import 'package:traffic_lights_assignment/utils.dart';

class TrafficLightWidget extends StatefulWidget {
  final TrafficLightStatus currentColor;
  final bool isRandom;

  const TrafficLightWidget({
    super.key,
    required this.currentColor,
    this.isRandom = false,
  });

  @override
  State<TrafficLightWidget> createState() => _TrafficLightWidgetState();
}

class _TrafficLightWidgetState extends State<TrafficLightWidget> {
  late TrafficLightStatus _currentStatus;
  late Stopwatch _stopwatch;
  late int randomDelay;

  static const int cycleDuration = 9000;

  @override
  void initState() {
    super.initState();
    randomDelay = widget.isRandom ? Random().nextInt(5000) : 0;
    _currentStatus = widget.currentColor;
    _stopwatch = Stopwatch()..start();
    if (widget.isRandom) {
      startRandomTrafficLightCycle();
    }
  }

  @override
  void didUpdateWidget(TrafficLightWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRandom != oldWidget.isRandom) {
      randomDelay = widget.isRandom ? Random().nextInt(5000) : 0;
      if (widget.isRandom) {
        startRandomTrafficLightCycle();
      } else {
        setState(() {
          _currentStatus = widget.currentColor;
        });
      }
    }
  }

  void startRandomTrafficLightCycle() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!widget.isRandom) {
        timer.cancel();
        return;
      }

      final int elapsedTime =
          (_stopwatch.elapsedMilliseconds + randomDelay) % cycleDuration;

      setState(() {
        _currentStatus = getTrafficLightStatus(elapsedTime, cycleDuration);
      });
    });
  }

  BoxDecoration getBoxDecoration(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  Container light(Color color) {
    const lightRadius = 40.0;
    return Container(
      height: lightRadius,
      width: lightRadius,
      decoration: getBoxDecoration(color, 50),
    );
  }

  Column trafficLightColumn(TrafficLightStatus trafficLight) {
    Color offColor = Colors.grey.shade400;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        light(trafficLight == TrafficLightStatus.red ||
                trafficLight == TrafficLightStatus.redYellow
            ? Colors.red
            : offColor),
        light(trafficLight == TrafficLightStatus.redYellow ||
                trafficLight == TrafficLightStatus.yellow
            ? Colors.yellow
            : offColor),
        light(
            trafficLight == TrafficLightStatus.green ? Colors.green : offColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const trafficLightWidth = 55.0;
    const trafficLightHeight = 170.0;

    return Container(
      width: trafficLightWidth,
      height: trafficLightHeight,
      decoration: getBoxDecoration(Colors.grey.shade900, 10),
      child: trafficLightColumn(
          widget.isRandom ? _currentStatus : widget.currentColor),
    );
  }
}
