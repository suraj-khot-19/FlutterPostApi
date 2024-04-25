import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  //function to pick image
  Future getImage() async {
    final PickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (PickedFile != null) {
      image = File(PickedFile.path);
      setState(() {});
    } else {
      print("isuue...");
    }
  }

//function to upload image
  Future<void> uploadImage() async {
    setState(() {
      showSpinner =
          true; //changing value while uploading image to show progress bar
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = new http.MultipartRequest('POST', uri);
    request.fields['title'] = "Static title";
    var multiport = new http.MultipartFile('image', stream, length);

    request.files.add(multiport);
    var response = await request.send();
    //printing response on console
    print(response.stream.toString());
    if (response.statusCode == 200) {
      setState(() {
        showSpinner =
            false; //changing value while uploading image to show progress bar
      });
      print("image uploaded");
    } else {
      print("failed...");
      setState(() {
        showSpinner =
            false; //changing value while uploading image to show progress bar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner, //initialy false
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Upload Image Using POST Api"),
          ),
          backgroundColor: Colors.grey[100],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  child: image == null
                      ? const Center(
                          child: Text(
                            "click here to pick image from gallary",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      : Container(
                          height: 400,
                          width: 400,
                          child: Center(
                            child: Image.file(
                              File(image!.path).absolute,
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.purple[200],
                  ),
                  child: const Center(
                    child: Text(
                      "Upload",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
