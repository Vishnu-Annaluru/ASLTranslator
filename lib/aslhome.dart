import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ASLHome extends StatefulWidget {
  List<CameraDescription> cameras;
  ASLHome({
    super.key,
    required this.cameras,
  });

  @override
  ASLHomeState createState() => ASLHomeState();
}

/////////////////////////////NEXT STEP IS GETTING EACH FRAME

class ASLHomeState extends State<ASLHome> {
  File? imageFile;
  bool gallery = false;
  bool camera = false;
  late CameraController controller;

  String text = "Text will be displayed here";
  double fSize = 15;

  String ip = "http://192.168.1.240";

  Future<File> fileFromAsset(String path) async {
    final byteData = await rootBundle.load(path);

    //Directory tempDirectory = await getTemporaryDirectory();

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return file;
  }

  Future pickFromGallery() async {

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(image!.path);
    });

    getResponse(imageFile);
  }

  Future pickFromCamera() async {
    Future<XFile> picture = controller.takePicture();
    File pictureFile = File((await picture).path);
    GallerySaver.saveImage(pictureFile.path).then((String path) {
      setState(() {
        //print("PICTURE SAVED");
      });
    } as FutureOr Function(bool? value));

    
  }

  Future getResponse(File? file) async {
    var url = Uri.parse('http://10.0.2.2:5000/apiModel/get');
    var request = http.MultipartRequest('POST', url);
    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    request.files.add(
      http.MultipartFile(
        'image',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split("/").last,
      ),
    );
    request.headers.addAll(headers);
    var streamResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamResponse);

    //final responseJson = jsonDecode(json.encode(response.body.toString()));
    String message = response.body.toString();

    setState(() {
      text = message;
      fSize = 45;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer timer;
    controller = CameraController(widget.cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        int id = 0;
        timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          
          Future<XFile> picture = controller.takePicture();
          File pictureFile = File((await picture).path);

          getResponse(pictureFile);
          id++;

        });

        controller.startImageStream((image) async {
          //print(image.width.toString() + " " + image.height.toString());

          // Uint8List jpegData = image.planes[0].bytes;
          // Directory tempDir = await getTemporaryDirectory();
          // File file = File('${tempDir.path}/frame$id.jpg');

          // await file.writeAsBytes(jpegData);

          // getResponse(file);

          // tempDir.deleteSync(recursive: true);
          // tempDir.create();
          // id++;
        });
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            
            break;
          default:
            
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
            Center(
              child: Text(
                "Translate sign language and text",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    int l = widget.cameras.length;
                    setState(() {
                      gallery = true;
                      camera = false;
                    });
                    pickFromGallery();
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
                    pickFromCamera();
                  },
                  icon: Icon(Icons.camera_alt),
                  color: !camera ? Colors.grey : Colors.blue,
                  iconSize: 35,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
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
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: fSize),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
