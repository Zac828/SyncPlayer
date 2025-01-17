import 'package:flutter/material.dart';
import 'package:sync_video/home/home_bloc.dart';

class ConfigureForm extends StatelessWidget {
  final HomeBloc bloc;

  ConfigureForm({this.bloc});

  @override
  Widget build(BuildContext context) {
    int _minute = 0;
    int _second = 0;
    int _millisecond = 0;
    double _speed = 1.0;

    List<String> doubleList = List<String>.generate(59, (int index) => '$index');
    List<DropdownMenuItem> menuItemList = doubleList
        .map((val) => DropdownMenuItem(value: val, child: Center(child: Text(val, style: TextStyle(fontSize: 18)))))
        .toList();

    List<String> msecList = List<String>.generate(10, (int index) => '$index');
    List<DropdownMenuItem> msecItemList = msecList
        .map((val) => DropdownMenuItem(value: val, child: Center(child: Text( (int.parse(val) / 10).toString(), style: TextStyle(fontSize: 18) ))))
        .toList();

    List<String> speedList = List<String>.generate(10, (int index) => '${index}');
    List<DropdownMenuItem> speedItemList = speedList.reversed
        .map((val) => DropdownMenuItem(value: val, child: Center(child: Text( ((double.parse(val) + 1) / 10).toString(), style: TextStyle(fontSize: 18) ))))
        .toList();

    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: '分',
                          hintText: '00',
                          labelStyle: TextStyle(fontSize: 20)
                      ),
                      onChanged: (value) {
                        _minute = int.parse(value);
                      },
                      items: menuItemList,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: '秒',
                          hintText: '00',
                          labelStyle: TextStyle(fontSize: 20)
                      ),
                      onChanged: (value) {
                        _second = int.parse(value);
                      },
                      items: menuItemList,
                    ),
                  )
                ],
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: '秒(小數點)',
                  hintText: '0.1',
                  labelStyle: TextStyle(fontSize: 20)
                ),
                onChanged: (value) {
                  _millisecond = int.parse(value);
                },
                items: msecItemList,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: '速度(小數點)',
                    hintText: '1.0',
                    labelStyle: TextStyle(fontSize: 20)
                ),
                onChanged: (value) {
                  _speed = (double.parse(value) + 1) / 10;
                },
                items: speedItemList,
              ),
              Padding(padding: EdgeInsets.all(8)),
              FlatButton(
                onPressed: () {
                  bloc.add(HomeConfigDoneEvent(minute: _minute, second: _second, millisecond: _millisecond, speed: _speed));
                },
                child: Text('確定', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
