import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locker_calculator/screens/gallery.dart';
import 'package:locker_calculator/screens/home.dart';
import 'package:locker_calculator/styles/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Locker_page extends StatefulWidget {
  const Locker_page({super.key});

  @override
  State<Locker_page> createState() => Locker_pageState();
}

// ignore: camel_case_types
class Locker_pageState extends State<Locker_page> {
  List<String> base64Images = [];

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      String base64 = base64Encode(Uint8List.fromList(imageBytes));

      setState(() {
        base64Images.add(base64);
      });

      saveImages(base64Images);
    }
  }

  Future<void> removeImage(int index) async {
    setState(() {
      base64Images.removeAt(index);
    });
    saveImages(base64Images);
  }

  Widget buildImages() {
    int columns = 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: base64Images.length,
      itemBuilder: (BuildContext context, int index) {
        Uint8List bytes = base64Decode(base64Images[index]);
         return InkWell(
        onTap: () => openGallery(index),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.memory(
              bytes,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 95,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => removeImage(index),
              ),
            ),
          ],
        )
        );
      },
    );
  }

  Future<void> saveImages(List<String> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('base64Images', images);
  }

  Future<void> loadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? images = prefs.getStringList('base64Images');
    if (images != null) {
      setState(() {
        base64Images = images;
      });
    }
  }


  void openGallery(int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPage(
        images: base64Images,
        initialIndex: index,
      ),
    ),
  );
}

  @override
  void initState() {
    super.initState();

    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: UIColorStyles.DEEP_MODE,
      title:Text('Locker') ,
       centerTitle: true,

      
       actions: [
         Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  HomePage(),
                    ));
              },
             
      child: Image.asset(
        'assets/logo.png',  
        width: 50.0, 
        height: 50.0,  
        fit: BoxFit.cover,
      ),
       
    )
       
    ),
       ]
    ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ElevatedButton(
              //   onPressed: () => pickImage(),
              //   child: const Text('Add Image'),
              // ),
           
              buildImages(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
      margin: EdgeInsets.only(bottom: 16.0, ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () => pickImage(),
          backgroundColor: UIColorStyles.DEEP_MODE,
          child: Icon(Icons.add_a_photo),
        ),
      ),
    ),
    );
  }
   
}
