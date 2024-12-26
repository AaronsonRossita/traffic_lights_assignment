enum TrafficLightBehavior { synchronized, chaos }

extension TrafficLightBehaviorExtension on TrafficLightBehavior {
  String get name {
    switch (this) {
      case TrafficLightBehavior.synchronized:
        return 'Synchronized';
      case TrafficLightBehavior.chaos:
        return 'Chaos';
    }
  }
}

enum TrafficLightStatus { red, redYellow, green, yellow }