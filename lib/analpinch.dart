import 'cascadePainter.dart';
import 'package:flutter/material.dart';
import 'currentsTable.dart';
import 'analpinchdata.dart';
import 'package:scoped_model/scoped_model.dart';
import 'toolsbar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AnalisisPinch extends StatelessWidget {
  final model;
  const AnalisisPinch({@required this.model, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AnalPinchData>(
      child: MaterialApp(
        title: 'Analisis Pinch',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
              return WebLayout();
            return MobileLayout();
          },
        ),
      ),
      model: model,
    );
  }
}

class MobileLayout extends StatefulWidget {
  MobileLayout({Key key}) : super(key: key);

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {},
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Text(
          "Not Supported Resolution",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class WebLayout extends StatefulWidget {
  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);

    return Scaffold(
      appBar: ToolsBar(),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 10,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: model.nightMode ? Colors.grey[900] : Colors.white,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      CurrentBuilder(),
                    ],
                  )),
            ),
            flex: model.flex1.toInt(),
          ),
          VerticalDivider(
            endIndent: 0,
            indent: 0,
            width: 1,
            thickness: 1,
            color: Colors.blueGrey,
          ),
          Expanded(
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: model.nightMode ? Colors.grey[900] : Colors.white,
              child: CascadePainter(),
            ),
            flex: model.flex2.toInt(),
          ),
        ],
      ),
    );
  }
}
