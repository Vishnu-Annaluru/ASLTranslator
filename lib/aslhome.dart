import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ASLHome extends StatefulWidget {
  List<CameraDescription> cameras;
  ASLHome({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  ASLHomeState createState() => ASLHomeState();
}

class ASLHomeState extends State<ASLHome> {
  File? imageFile;
  bool gallery = false;
  bool camera = false;
  late CameraController controller;

  Future pickFromGallery() async {
    print("method called bro");
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      imageFile = File(image.path);
    });
  }

  Future pickFromCamera() async {
    print("method called cameara bro");
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      imageFile = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.startImageStream((image) {
          print(image.width.toString() + " " + image.height.toString());
        });
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            Text(
              "Translate sign language and text",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    int l = widget.cameras.length;
                    print("cameras: $l");
                    setState(() {
                      gallery = true;
                      camera = false;
                    });
                    //pickFromGallery();
                  },
                  icon: Icon(Icons.photo_library),
                  color: !gallery ? Colors.grey : Colors.blue,
                  iconSize: 35,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      camera = true;
                      gallery = false;
                    });
                    //pickFromCamera();
                  },
                  icon: Icon(Icons.camera_alt),
                  color: !camera ? Colors.grey : Colors.blue,
                  iconSize: 35,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: controller.value.isInitialized
                  ? CameraPreview(controller)
                  : Text(
                      "Enable Camera",
                      style: TextStyle(color: Colors.black),
                    ),
              // child: imageFile != null
              //     ? Image.file(imageFile!)
              //     : Text(
              //         "No image selected",
              //         style: TextStyle(color: Colors.black),
              //       ),
            ),
            SizedBox(height: 30),
            Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Text will be displayed here",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
