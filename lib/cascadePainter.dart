import 'dart:ui';
import 'myObjects.dart';
import 'package:flutter/material.dart';
import 'analpinchdata.dart';
import 'package:scoped_model/scoped_model.dart';

class CascadePainter extends StatefulWidget {
  @override
  _CascadePainterState createState() => _CascadePainterState();
}

class _CascadePainterState extends State<CascadePainter> {
  Offset deltaOffset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    void _handlePanUpdate(DragUpdateDetails details) {
      setState(() {
        deltaOffset = deltaOffset + details.delta;
      });
    }

    return Container(
      height: h,
      width: w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: _handlePanUpdate,
        child: CustomPaint(
          size: Size(w, h),
          painter: _CascadePainter(
            model: model,
            offset: deltaOffset,
          ),
        ),
      ),
    );
  }
}

class _CascadePainter extends CustomPainter {
  AnalPinchData model;
  Offset offset;
  double yScale;
  _CascadePainter({this.model, this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint();
    yScale = model.yScale;
    int dec = model.dec.toInt();
    double deb = dec.toDouble() * 0.1;
    List<Temperatura> tArray = model.getTemperatures();
    Offset sD = Offset(50, size.height * 0.8) + offset;
    paint.color = Colors.grey;

    //Draw Temperature Marks
    for (int i = 0; i < tArray.length; i++) {
      double _yPos = -tArray[i].y;
      Offset lineStart = sD + Offset(50, _yPos);
      Offset lineEnd = sD + Offset(size.width / 3 + deb * 50, _yPos);
      String _text = "T= " + tArray[i].t.toStringAsFixed(dec);
      TextPainter tp = customText(_text);
      canvas.drawLine(lineStart, lineEnd, paint);
      tp.layout();
      tp.paint(canvas, Offset(-40 * deb, _yPos) + sD);
    }

    //Draw Current Colored Lines
    for (int i = 0; i < model.currents.length; i++) {
      Current current = model.currents[i];
      paint.color = current.type;
      double _yStart;
      double _yEnd;
      for (int i = 0; i < tArray.length; i++) {
        if (current.tf == tArray[i].t) {
          _yEnd = -tArray[i].y;
        }
        if (current.ti == tArray[i].t) {
          _yStart = -tArray[i].y;
        }
      }
      Offset lineStart = sD + Offset(50 + i * 20.toDouble(), _yStart);
      Offset lineEnd = sD + Offset(50 + i * 20.toDouble(), _yEnd);
      canvas.drawLine(lineStart, lineEnd, paint);
      TextPainter tp = customText(current.name);
      tp.layout();
      tp.paint(canvas, lineStart);
    }

    //Draw Entalpy
    List<DeltaH> deltas = model.getDeltaHs();

    deltas.forEach((delta) {
      if (delta.entalpy != 0) {
        paint.color = Colors.grey;
        double yPos = delta.yPos;
        double entalpy = delta.entalpy;
        Offset _pos = sD + Offset(size.width / 3 + 50 * deb, -yPos);
        String text =
            "ΔT = ${(delta.t2 - delta.t1).toStringAsFixed(model.dec.toInt())}    CP = ${delta.sumCp.toStringAsFixed(model.dec.toInt())}   ΔH = ${entalpy.toStringAsFixed(model.dec.toInt())}";
        TextPainter tp = customText(text);
        tp.layout();
        tp.paint(canvas, _pos);
      }
    });

    //Calor Titulo Cascada y Corregida
    TextPainter tp = customText("Calor de Cascada");
    TextPainter tpCC = customText("Calor de Corregido");
    double xPos = size.width / 3 + 350;
    Offset _pos =
        sD + Offset(xPos + deb * 50, -tArray[tArray.length - 1].y - 50);
    Offset _posCC =
        sD + Offset(xPos + 200 + deb * 50, -tArray[tArray.length - 1].y - 50);
    tp.layout();
    tpCC.layout();
    tp.paint(canvas, _pos);
    tpCC.paint(canvas, _posCC);

    //Calores De Cascada
    List<CalorCascada> qCascada = model.getCaloresCascada();
    qCascada.forEach((element) {
      TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[600]),
        text: element.entalpy.toStringAsFixed(model.dec.toInt()),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);

      Offset _pos = sD +
          Offset(size.width / 3 + 350 + deb * 50,
              -element.temperature * yScale / 50);
      tp.layout();
      tp.paint(canvas, _pos);
    });

    //Calores De Cascada Corregidos
    List<CalorCascada> qCascadaCorregidos = model.getCaloresCascadaCorregidos();
    qCascadaCorregidos.forEach((element) {
      TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[600]),
        text: element.entalpy.toStringAsFixed(model.dec.toInt()),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);

      Offset _pos = sD +
          Offset(size.width / 3 + 550 + deb * 50,
              -element.temperature * yScale / 50);
      tp.layout();
      tp.paint(canvas, _pos);
    });
  }

  @override
  bool shouldRepaint(_CascadePainter old) => true;
}

TextSpan customSpan(String text) {
  return TextSpan(
    style: new TextStyle(color: Colors.grey[600]),
    text: text,
  );
}

TextPainter customText(String text) {
  TextSpan span = customSpan(text);
  return new TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
}
