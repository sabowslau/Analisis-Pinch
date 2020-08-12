import 'package:flutter/material.dart';

class DeltaH {
  double t1 = 1.0;
  double t2 = 2.0;
  double sumCp = 1.0;
  double yPos = 1.0;
  double entalpy = 1.0;

  DeltaH({this.t1: 1, this.t2: 1, this.sumCp: 1, this.yPos: 1});

  void calculateEntalpy() {
    entalpy = (t2 - t1) * (sumCp);
  }
}

class Current {
  String name;
  Color type;
  double cp;
  double heatCapacityFlowRate;
  double ti;
  double tf;
  bool lock;

  Current({
    this.name: "1",
    this.cp: 0.0,
    this.ti: 0.0,
    this.tf: 0.0,
    this.lock: false,
    this.type: Colors.grey,
  });

  void determinateType() {
    if (tf > ti) {
      // Cold Type
      this.type = Colors.blue;
    } else {
      // Hot Type
      this.type = Colors.red;
    }
  }

  void changeName(newName) {
    name = newName;
  }

  void changeCp(newCp) {
    cp = newCp;
  }

  void changeSourceTemperature(newT) {
    ti = newT;
    determinateType();
  }

  void changeTargetTemperature(newT) {
    tf = newT;
    determinateType();
  }

  void toggleLock(bool _newState) {
    lock = _newState;
  }
}

class CalorCascada {
  double entalpy;
  double temperature;
  double yPos;
  CalorCascada({this.entalpy: 1, this.temperature: 1, this.yPos: 0});
}

class Temperatura {
  double t;
  double y;
  Temperatura({this.t: 1, this.y: 1});
}
