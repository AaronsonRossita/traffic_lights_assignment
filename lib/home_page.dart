import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traffic_lights_assignment/enums.dart';
import 'package:traffic_lights_assignment/traffic_light_widget.dart';
import 'package:traffic_lights_assignment/utils.dart';  // Import the utility file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int amount = 1000;

  late TrafficLightBehavior _currentBehavior = TrafficLightBehavior.synchronized;
  TrafficLightStatus _currentStatus = TrafficLightStatus.red;

  Timer? _syncTimer;

  static const int cycleDuration = 9000;

  @override
  void initState() {
    super.initState();
    startSynchronizedTrafficLightCycle();
  }

  SliverGridDelegateWithFixedCrossAxisCount gridDelegate() {
    double availableWidth = MediaQuery.of(context).size.width - 40;
    int trafficLightsPerRow = availableWidth ~/ 65;

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: trafficLightsPerRow,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 65 / 190,
    );
  }

  ButtonStyle buttonDesign() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.blue[900]!;
        } else if (states.contains(MaterialState.hovered)) {
          return Colors.blue[700]!;
        } else {
          return Colors.blue;
        }
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
      minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 3, 40)),
    );
  }

  void buttonAction() {
    setState(() {
      _currentBehavior = _currentBehavior == TrafficLightBehavior.synchronized
          ? TrafficLightBehavior.chaos
          : TrafficLightBehavior.synchronized;

      if (_currentBehavior == TrafficLightBehavior.synchronized) {
        resetToSynchronized();
      }
    });
  }

  void resetToSynchronized() {
    _syncTimer?.cancel();
    _currentStatus = TrafficLightStatus.red;
    startSynchronizedTrafficLightCycle();
  }

  void startSynchronizedTrafficLightCycle() {
    _syncTimer?.cancel();

    _syncTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = timer.tick * 100;
      setState(() {
        _currentStatus = getTrafficLightStatus(elapsed, cycleDuration);
      });
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: buttonDesign(),
                  onPressed: buttonAction,
                  child: Text(_currentBehavior == TrafficLightBehavior.chaos
                      ? TrafficLightBehavior.synchronized.name
                      : TrafficLightBehavior.chaos.name),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: gridDelegate(),
                itemCount: amount,
                itemBuilder: (context, index) {
                  return TrafficLightWidget(
                    currentColor: _currentStatus,
                    isRandom: _currentBehavior == TrafficLightBehavior.chaos,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
