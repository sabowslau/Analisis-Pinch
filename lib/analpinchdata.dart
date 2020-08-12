import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';
import 'myObjects.dart';

class AnalPinchData extends Model {
  List<Current> currents = List()..add(Current(name: "1"));
  List<Temperatura> sortedTemps = List();
  int currentAmount = 2;
  double flex1 = 10;
  double flex2 = 20;
  double valueSlider = 0.3;
  double yScale = 50.0;
  double dec = 0;
  bool nightMode = false;

  void toggleNightMode() {
    nightMode = !nightMode;
    notifyListeners();
  }

  void changeDecimals(double newVal) {
    dec = newVal.roundToDouble();
    notifyListeners();
  }

  void upDecimal() {
    dec++;
    if (dec > 6) {
      dec = 6;
    }
    notifyListeners();
  }

  void downDecimal() {
    dec--;
    if (dec <= 0) {
      dec = 0;
    }
    notifyListeners();
  }

  void moveYScale(double newVal) {
    yScale = newVal;
    notifyListeners();
  }

  void moveFlex(double preference) {
    flex1 = 20 * preference;
    flex2 = 20 * (1 - preference);
    valueSlider = preference;
    notifyListeners();
  }

  void addCurrent() {
    currents.add(Current(name: currentAmount.toString()));
    currentAmount++;
    notifyListeners();
  }

  void changeCurrentCp(int _index, double newCp) {
    if (newCp != 0 && newCp != null) {
      currents[_index].changeCp(newCp);
      notifyListeners();
    }
  }

  void changeCurrentSourceTemperature(int _index, double newT) {
    if (newT != 0 && newT != null) {
      currents[_index].changeSourceTemperature(newT);
      notifyListeners();
    }
  }

  void changeCurrentTargetTemperature(int _index, double newT) {
    if (newT != 0 && newT != null) {
      currents[_index].changeTargetTemperature(newT);
      notifyListeners();
    }
  }

  void removeCurrent(int index) {
    if (!currents[index].lock) {
      currents.removeAt(index);
    }

    notifyListeners();
  }

  void changeCurrentName(int _index, String newName) {
    currents[_index].changeName(newName);
    notifyListeners();
  }

  void toggleCurrentLock(int _index, bool _newState) {
    currents[_index].toggleLock(_newState);
    notifyListeners();
  }

  List<Temperatura> getTemperatures() {
    List<double> _temperatures = List();
    currents.forEach((e) {
      _temperatures.add(e.ti);
    });
    currents.forEach((e) {
      _temperatures.add(e.tf);
    });
    _temperatures.sort((a, b) => a.compareTo(b));
    sortedTemps = cleanTemperatures(_temperatures);

    return sortedTemps;
  }

  List<Temperatura> cleanTemperatures(List<double> oldT) {
    List<double> newTs = oldT.toSet().toList();
    List<Temperatura> realT = List();
    double _yPos = 0;
    newTs.forEach((element) {
      realT.add(Temperatura(t: element, y: _yPos));
      _yPos = _yPos + 50;
    });

    return realT;
  }

  List<DeltaH> getDeltaHs() {
    List<DeltaH> _deltas = List();
    for (int i = 0; i < sortedTemps.length - 1; i++) {
      double t1 = sortedTemps[i].t;
      double t2 = sortedTemps[i + 1].t;
      double deltaCp = getDeltaCp(t1, t2);
      _deltas.add(
        DeltaH(
          t1: sortedTemps[i].t,
          t2: sortedTemps[i + 1].t,
          sumCp: deltaCp,
          yPos: sortedTemps[i].y + 25,
        ),
      );
    }
    _deltas.forEach((element) {
      element.calculateEntalpy();
    });
    return _deltas;
  }

  double getDeltaCp(double t1, double t2) {
    double deltaCp = 0;
    currents.forEach((element) {
      if (element.type == Colors.red) {
        if (element.tf <= t1 && element.ti >= t2) {
          deltaCp = deltaCp + element.cp;
        }
      } else {
        if (element.tf >= t2 && element.ti <= t1) {
          deltaCp = deltaCp - element.cp;
        }
      }
    });

    return deltaCp;
  }

  void randomizer() {
    currents.forEach(
        (e) => e.changeCp((Random.secure().nextInt(10) + 1).toDouble()));

    currents.forEach((e) => e.changeSourceTemperature(
        (Random.secure().nextInt(500) + 1).toDouble()));

    currents.forEach((e) => e.changeTargetTemperature(
        (Random.secure().nextInt(500) + 1).toDouble()));

    notifyListeners();
  }

  List<CalorCascada> getCaloresCascada() {
    List<DeltaH> _deltas = getDeltaHs();
    double sumEntalpy = 0;
    List<CalorCascada> caloresCascada = List();
    for (int i = _deltas.length - 1; i >= 0; i--) {
      sumEntalpy = sumEntalpy + _deltas[i].entalpy;
      caloresCascada.add(CalorCascada(
        entalpy: sumEntalpy,
        temperature: _deltas[i].yPos,
      ));
    }

    return caloresCascada;
  }

  List<CalorCascada> getCaloresCascadaCorregidos() {
    List<CalorCascada> qCascada = getCaloresCascada();
    double sumEntalpy = getLower(qCascada);
    if (sumEntalpy < 0) {
      sumEntalpy = -sumEntalpy;
    }
    double lastT = 0;
    List<DeltaH> _deltas = getDeltaHs();
    List<CalorCascada> caloresCascadaCorregidos = List();
    for (int i = _deltas.length - 1; i >= 0; i--) {
      caloresCascadaCorregidos.add(CalorCascada(
        entalpy: sumEntalpy,
        temperature: _deltas[i].yPos,
      ));
      sumEntalpy = sumEntalpy + _deltas[i].entalpy;
      lastT = _deltas[i].yPos;
    }
    caloresCascadaCorregidos.add(CalorCascada(
      entalpy: sumEntalpy,
      temperature: lastT - 20,
    ));

    return caloresCascadaCorregidos;
  }

  double getLower(List<CalorCascada> list) {
    double minor = 10000000;
    list.forEach((element) {
      if (element.entalpy < minor) {
        minor = element.entalpy;
      }
    });
    return minor;
  }
}
