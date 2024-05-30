import 'package:brailleaslapp/aslhome.dart';
import 'package:brailleaslapp/braillehome.dart';
import 'package:brailleaslapp/homepage.dart';
import 'package:brailleaslapp/settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

//import 'package:restaurantpickerandroid/loginpage.dart';
class Main2 extends StatefulWidget {

  List<CameraDescription> cameras;

  Main2({super.key, required this.cameras,});

  @override
  _Main2State createState() => _Main2State();
}

class _Main2State extends State<Main2> {
  late List<Widget> pages;
  late List sendToHomeList = [];
  int _selected = 0;
  String? lat, long, country, adminArea;
  void _navigate(int index) {
    setState(() {
      _selected = index;
    });
  }

  // dynamic getCameras() async {
  //   return await availableCameras();
  // }

  // CameraDescription setCamera()  {
  //   final cameras =  getCameras();
  //   return cameras.first;
  // }

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      BrailleHome(),
      ASLHome(cameras: widget.cameras,),
      Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[2],
      
    );
  }
}
