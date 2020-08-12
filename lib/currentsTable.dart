import 'package:flutter/material.dart';
import 'analpinchdata.dart';
import 'package:scoped_model/scoped_model.dart';

Color bg300 = Colors.blueGrey[300];
TextStyle tsN = TextStyle(color: bg300);

class CurrentBuilder extends StatefulWidget {
  @override
  _CurrentBuilderState createState() => _CurrentBuilderState();
}

class _CurrentBuilderState extends State<CurrentBuilder> {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AnalPinchData>(context, rebuildOnChange: true);
    // Current current1 = model.currents[0];
    return Card(
      color: model.nightMode ? Colors.blueGrey[900] : Colors.white,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          tableDescription,
          ...currentsTableBuilder(model),
        ],
      ),
    );
  }
}

List<TableRow> currentsTableBuilder(AnalPinchData model) {
  List<TableRow> tables = List();
  int amount = model.currents.length;

  for (int i = 0; i < amount; i++) {
    TableRow newTable = currentInputRows(model, i);
    tables.add(newTable);
  }

  return tables;
}

TableRow tableDescription = TableRow(
  children: [
    titles("Lock"),
    titles("Name"),
    titles("Cp"),
    titles("Ti"),
    titles("Tf"),
    titles("Type"),
    titles("Sup"),
  ],
);

TableRow currentInputRows(AnalPinchData model, int _index) {
  bool lockedState = model.currents[_index].lock;

  void lockRow() {
    bool _newState = !lockedState;
    model.toggleCurrentLock(_index, _newState);
  }

  return TableRow(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            lockRow();
          },
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              lockedState ? Icons.lock : Icons.lock_open,
              color: lockedState ? bg300 : Colors.blue[300],
            ),
          ),
        ),
      ),
      if (lockedState) ...nonEditableStreamDisplay(model, _index),
      if (!lockedState) ...editableStreamDisplay(model, _index),
      Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            model.removeCurrent(_index);
          },
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              Icons.delete,
              color: bg300,
            ),
          ),
        ),
      ),
    ],
  );
}

List<Widget> nonEditableStreamDisplay(AnalPinchData model, int _index) {
  return [
    lockedText(model.currents[_index].name),
    lockedText(model.currents[_index].cp.toStringAsFixed(model.dec.toInt())),
    lockedText(model.currents[_index].ti.toStringAsFixed(model.dec.toInt())),
    lockedText(model.currents[_index].tf.toStringAsFixed(model.dec.toInt())),
    Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: model.currents[_index].type,
        ),
      ),
    ),
  ];
}

List<Widget> editableStreamDisplay(AnalPinchData model, int _index) {
  return [
    TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: model.currents[_index].name,
      ),
      onChanged: (newName) {
        model.changeCurrentName(_index, newName);
      },
    ),
    TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: model.currents[_index].cp.toStringAsFixed(model.dec.toInt()),
      ),
      onChanged: (newCp) {
        model.changeCurrentCp(_index, double.tryParse(newCp));
      },
    ),
    TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: model.currents[_index].ti.toStringAsFixed(model.dec.toInt()),
      ),
      onChanged: (newT) {
        model.changeCurrentSourceTemperature(_index, double.tryParse(newT));
      },
    ),
    TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: model.currents[_index].tf.toStringAsFixed(model.dec.toInt()),
      ),
      onChanged: (newT) {
        model.changeCurrentTargetTemperature(_index, double.tryParse(newT));
      },
    ),
    Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: model.currents[_index].type,
        ),
      ),
    ),
  ];
}

Widget titles(String text) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Center(
      child: Text(
        text,
        style: tsN,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget lockedText(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: tsN,
  );
}
