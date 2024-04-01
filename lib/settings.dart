import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Hello Settings",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}