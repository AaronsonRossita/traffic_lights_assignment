import 'enums.dart';

const int redDuration = 3000;
const int redYellowDuration = 4500;
const int greenDuration = 7500;

TrafficLightStatus getTrafficLightStatus(int elapsedTime, int cycleDuration) {
  final int cycleTime = elapsedTime % cycleDuration;

  if (cycleTime < redDuration) {
    return TrafficLightStatus.red;
  } else if (cycleTime < redYellowDuration) {
    return TrafficLightStatus.redYellow;
  } else if (cycleTime < greenDuration) {
    return TrafficLightStatus.green;
  } else {
    return TrafficLightStatus.yellow;
  }
}

