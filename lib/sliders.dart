import 'package:flutter/material.dart';
import 'analpinchdata.dart';
import 'package:scoped_model/scoped_model.dart';

class RatioSlider extends StatefulWidget {
  @override
  _RatioSliderState createState() => _RatioSliderState();
}

class _RatioSliderState extends State<RatioSlider> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "Expandir UI",
                style: TextStyle(
                    color: Colors.blue[300], fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: model.nightMode
                        ? Colors.blueGrey[900]
                        : Colors.grey[300],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Slider(
                      activeColor: Colors.blue[300],
                      value: model.valueSlider,
                      max: 0.8,
                      min: 0.23,
                      onChanged: (val) {
                        model.moveFlex(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          YScaleSlider(),
          DecimalSlider(),
        ],
      ),
    );
  }
}

class YScaleSlider extends StatefulWidget {
  @override
  _YScaleSliderState createState() => _YScaleSliderState();
}

class _YScaleSliderState extends State<YScaleSlider> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);

    return Column(
      children: <Widget>[
        Text(
          "Expandir Y",
          style:
              TextStyle(color: Colors.blue[300], fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: model.nightMode ? Colors.blueGrey[900] : Colors.grey[300],
            ),
            child: Material(
              color: Colors.transparent,
              child: Slider(
                activeColor: Colors.blue[300],
                value: model.yScale,
                min: 1,
                max: 300,
                onChanged: (val) {
                  model.moveYScale(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DecimalSlider extends StatefulWidget {
  @override
  _DecimalSliderState createState() => _DecimalSliderState();
}

class _DecimalSliderState extends State<DecimalSlider> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);

    return Column(
      children: <Widget>[
        Text(
          "Decimales",
          style:
              TextStyle(color: Colors.blue[300], fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: model.nightMode ? Colors.blueGrey[900] : Colors.grey[300],
            ),
            child: Material(
              color: Colors.transparent,
              child: Slider(
                activeColor: Colors.blue[300],
                value: model.dec,
                divisions: 7,
                min: 0,
                max: 8,
                onChanged: (val) {
                  model.changeDecimals(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
