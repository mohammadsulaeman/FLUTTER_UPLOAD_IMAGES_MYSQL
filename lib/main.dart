import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  ImagePicker picker = ImagePicker();
  TextEditingController controllerTitle = TextEditingController();
  Future openCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future openGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future upload(File imageFile) async {
    var Stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url = Uri.parse("http://192.168.206.108/images/upload.php");

    var request = http.MultipartRequest("POST", url);

    var MultipartFile = http.MultipartFile("image", Stream, length,
        filename: basename(imageFile.path));

    request.fields['title'] = controllerTitle.text;
    request.files.add(MultipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Berhasil Terupload");
    } else {
      print("Upload Image Gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _image == null
                  ? const Text("No Image Selected")
                  : Image.file(
                      _image!,
                      width: 300,
                      height: 300,
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Title",
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                controller: controllerTitle,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: openGallery,
                  child: const Icon(Icons.image),
                ),
                ElevatedButton(
                  onPressed: openCamera,
                  child: const Icon(Icons.camera_alt),
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: () {
                    upload(_image!);
                  },
                  child: const Text('Upload'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
