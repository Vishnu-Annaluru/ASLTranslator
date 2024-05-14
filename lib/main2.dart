import 'package:brailleaslapp/aslhome.dart';
import 'package:brailleaslapp/braillehome.dart';
import 'package:brailleaslapp/homepage.dart';
import 'package:brailleaslapp/settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'main.dart';

//import 'package:restaurantpickerandroid/loginpage.dart';
class Main2 extends StatefulWidget {

  List<CameraDescription> cameras;

  Main2({Key? key, required this.cameras,}) : super(key: key);

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
      // body: IndexedStack(
      //   index: _selected,
      //   children: pages,
      // ),
      // bottomNavigationBar: Container(
      //   color: const Color.fromARGB(255, 17, 17, 17),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //     child: GNav(
      //       backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      //       color: Colors.white,
      //       activeColor: Colors.teal[100],
      //       tabBackgroundColor: Colors.teal.shade900,
      //       padding: const EdgeInsets.all(16),
      //       gap: 10,
      //       selectedIndex: _selected,
      //       onTabChange: (index) {
      //         _navigate(index);
      //       },
      //       tabs: const [
      //         GButton(
      //           icon: Icons.home,
      //           text: "Home",
      //         ),
      //         GButton(
      //           icon: Icons.text_format,
      //           text: "Braille",
      //         ),
      //         GButton(
      //           icon: Icons.back_hand,
      //           text: "ASL",
      //         ),
      //         GButton(
      //           icon: Icons.settings,
      //           text: "Settings",
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
