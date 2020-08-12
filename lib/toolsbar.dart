import 'package:flutter/material.dart';
import 'analpinchdata.dart';
import 'package:scoped_model/scoped_model.dart';
import 'customDialog.dart';

Color bg300 = Colors.blueGrey[300];

class ToolsBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _ToolsBarState createState() => _ToolsBarState();
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _ToolsBarState extends State<ToolsBar> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blueGrey[100],
      title: Row(
        children: <Widget>[
          AddCurrent(),
          ToolButton(
            child: Text("D+"),
            onTap: model.upDecimal,
            tooltip: "More decimals",
          ),
          ToolButton(
            child: Text("D-"),
            onTap: model.downDecimal,
            tooltip: "Less decimals",
          ),
          ToolButton(
            child: Icon(Icons.brightness_2, color: bg300),
            onTap: model.toggleNightMode,
            tooltip: "Toggle night mode",
          ),
          Randomize(),
          Help(),
        ],
      ),
    );
  }
}

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  String key = "";

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "About",
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.help,
              color: bg300,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  description:
                      "this application was created to facilitate the energy calculations for the pinch analysis methodology, more information at https://es.wikipedia.org/wiki/An%C3%A1lisis_Pinch",
                  buttonText: "Back",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Randomize extends StatefulWidget {
  @override
  _RandomizeState createState() => _RandomizeState();
}

class _RandomizeState extends State<Randomize> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    return Tooltip(
      message: "Randomize Values",
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                model.randomizer();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.autorenew,
                  color: Colors.blueGrey[300],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddCurrent extends StatefulWidget {
  @override
  _AddCurrentState createState() => _AddCurrentState();
}

class _AddCurrentState extends State<AddCurrent> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    return Tooltip(
      message: "Add a new current",
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                model.addCurrent();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add,
                  color: Colors.blueGrey[300],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToolButton extends StatefulWidget {
  final child;
  final onTap;
  final tooltip;
  ToolButton({this.child, this.onTap, this.tooltip: ""});
  @override
  _ToolButtonState createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                widget.onTap();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
