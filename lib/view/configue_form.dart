import 'package:flutter/material.dart';
import 'package:sync_video/home/home_bloc.dart';

class ConfigureForm extends StatelessWidget {
  final HomeBloc bloc;

  ConfigureForm({this.bloc});

  @override
  Widget build(BuildContext context) {
    int _minute = 0;
    int _second = 0;

    List<String> doubleList = List<String>.generate(59, (int index) => '$index');
    List<DropdownMenuItem> menuItemList = doubleList
        .map((val) => DropdownMenuItem(value: val, child: Center(child: Text(val))))
        .toList();

    return Container(
      padding: EdgeInsets.all(32),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Form(
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: '分',
                hintText: '00',
              ),
              onChanged: (value) {
                _minute = int.parse(value);
              },
              items: menuItemList,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: '秒',
                hintText: '00',
              ),
              onChanged: (value) {
                _second = int.parse(value);
              },
              items: menuItemList,
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                bloc.add(HomeConfigDoneEvent(minute: _minute, second: _second));
              },
              child: Text('確定'),
            )
          ],
        ),
      ),
    );
  }
}
