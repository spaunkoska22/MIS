import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class LightSensor {
  late Function(double) _onLightLevelChanged;
  late Color _backgroundColor;

  void Function()? _disposeCallback;

  LightSensor({
    required Function(double) onLightLevelChanged,
    required Color backgroundColor,
  }) {
    _onLightLevelChanged = onLightLevelChanged;
    _backgroundColor = backgroundColor;
  }

  void start() {
    // Start listening to the light sensor
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculate the current light level based on the accelerometer readings
      double lightLevel = event.x.abs() + event.y.abs() + event.z.abs();
      // Call the _onLightLevelChanged callback with the current light level
      _onLightLevelChanged(lightLevel);
    });
  }

  void dispose() {
    // This is where you would stop listening to the light sensor
    // and clean up any resources used by the sensor
    _disposeCallback?.call();
  }
}
