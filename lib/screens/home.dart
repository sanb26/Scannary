import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/screens/drawer.dart';
import 'package:scannary_app/screens/scanImage.dart';


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ImagePicker _picker = ImagePicker();
  File? img;

  static GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: AppBarDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          'Scannary',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        backgroundColor: bgColor2,
        elevation: 0,
        actions: [
          IconButton(          
            icon: FaIcon(FontAwesomeIcons.search, size: MediaQuery.of(context).size.height*0.03 ,),
            onPressed: (){},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){}, 
        backgroundColor: bgColor2,
        label: Row(
          children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.camera),
              onPressed: ()async {
                chooseImage(ImageSource.camera);
              }, 
            ),
            Container(
              color: Colors.white.withOpacity(0.2),
              width: 2,
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.image),
              onPressed: () async {
                chooseImage(ImageSource.gallery);
              }, 
            ),
          ],
        ),
      ),
      
      //in the body write code for showing saved documents.
      body: Center(
        child: Text('display docs here.'),
      ),
    );
  }

  Future<File?> chooseImage(ImageSource src) async{
    try{
      //File holds path and XFile wraps the bytes of selected file
      final XFile? pickedImage = await _picker.pickImage(source: src);
      if(pickedImage != null){
        img = File(pickedImage.path);
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context)=> ScanImage(img!, animatedListKey)));
      }     
    }
    on PlatformException catch(e){
      print('Failed to pick image: $e');
    }    
  }


}

