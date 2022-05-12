import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_size_getter/image_size_getter.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/screens/cropPainter.dart';
import 'package:scannary_app/screens/editImage.dart';


class ScanImage extends StatefulWidget {

  File file;
  GlobalKey<AnimatedListState> animatedListKey;

  ScanImage(this.file, this.animatedListKey, {Key? key}) : super(key: key);

  @override
  State<ScanImage> createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  
  final GlobalKey key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  File? img;
  late double width, height;
  late Size imagePixelSize;
  bool isFile = false;
  late Offset tl, tr, bl, br;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    Timer(Duration(milliseconds: 2000), getImageSize);
  }

  void getImageSize(){
    dynamic imageBox = key.currentContext!.findRenderObject();
    width = imageBox.size.width;
    height = imageBox.size.height;
    imagePixelSize = ImageSizGetter.getSize(widget.file);
    tl = const Offset(20, 20);
    tr = Offset(width - 20, 20);
    bl = Offset(20, height-20);
    br = Offset(width-20, height-20);
    setState(() {
      isFile = true;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor2,
      key: _scaffoldKey,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Stack(
                children: [
                  GestureDetector(
                    onPanDown: (details){
                      double x1 = details.localPosition.dx;
                      double y1 = details.localPosition.dy;
                      double x2 = tl.dx;
                      double y2 = tl.dy;
                      double x3 = tr.dx;
                      double y3 = tr.dy;
                      double x4 = bl.dx;
                      double y4 = bl.dy;
                      double x5 = br.dx;
                      double y5 = br.dy;
                      if (sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= 0 &&
                          x1 < width / 2 &&
                          y1 < height / 2) {
                        //print(details.localPosition);
                        setState(() {
                          tl = details.localPosition;
                        });
                      } else if (sqrt((x3 - x1) * (x3 - x1) +
                                  (y3 - y1) * (y3 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= 0 &&
                          x1 < width &&
                          y1 < height / 2) {
                        setState(() {
                          tr = details.localPosition;
                        });
                      } else if (sqrt((x4 - x1) * (x4 - x1) +
                                  (y4 - y1) * (y4 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= height / 2 &&
                          x1 < width / 2 &&
                          y1 < height) {
                        setState(() {
                          bl = details.localPosition;
                        });
                      } else if (sqrt((x5 - x1) * (x5 - x1) +
                                  (y5 - y1) * (y5 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= height / 2 &&
                          x1 < width &&
                          y1 < height) {
                        setState(() {
                          br = details.localPosition;
                        });
                      }
                    },
                    onPanUpdate: (details){
                      double x1 = details.localPosition.dx;
                      double y1 = details.localPosition.dy;
                      double x2 = tl.dx;
                      double y2 = tl.dy;
                      double x3 = tr.dx;
                      double y3 = tr.dy;
                      double x4 = bl.dx;
                      double y4 = bl.dy;
                      double x5 = br.dx;
                      double y5 = br.dy;
                      if (sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= 0 &&
                          x1 < width / 2 &&
                          y1 < height / 2) {
                        //print(details.localPosition);
                        setState(() {
                          tl = details.localPosition;
                        });
                      } else if (sqrt((x3 - x1) * (x3 - x1) +
                                  (y3 - y1) * (y3 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= 0 &&
                          x1 < width &&
                          y1 < height / 2) {
                        setState(() {
                          tr = details.localPosition;
                        });
                      } else if (sqrt((x4 - x1) * (x4 - x1) +
                                  (y4 - y1) * (y4 - y1)) <
                              30 &&
                          x1 >= 0 &&
                          y1 >= height / 2 &&
                          x1 < width / 2 &&
                          y1 < height) {
                        setState(() {
                          bl = details.localPosition;
                        });
                      } else if (sqrt((x5 - x1) * (x5 - x1) +
                                  (y5 - y1) * (y5 - y1)) <
                              30 &&
                          x1 >= width / 2 &&
                          y1 >= height / 2 &&
                          x1 < width &&
                          y1 < height) {
                        setState(() {
                          br = details.localPosition;
                        });
                      }
                    },
                    child: SafeArea(
                      child:Container(
                          color: bgColor2,
                          //padding: EdgeInsets.only(top: 30),
                          //constraints: BoxConstraints(maxHeight: 850),
                          child: Image.file(widget.file, key: key),                       //Used to load images from the file system in the target device     
                      ) ,
                    ),
                  ),
                  isFile? SafeArea(
                    child: CustomPaint(
                      painter: CropPainter(tl,tr,bl,br),                //Custom class CropPainter will draw the edges on the image
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: bottomSheet()
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(){
    return Container(
      color: bgColor2,
      width: MediaQuery.of(context).size.width,
      //height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Adjust Edges',
             style: GoogleFonts.poppins(
               color: Colors.white,
               fontSize: MediaQuery.of(context).size.height*0.025,
             ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'Retake', 
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: MediaQuery.of(context).size.height*0.02,
                  ),
                ),
                onPressed: () async {
                  chooseImage(ImageSource.camera);
                }, 
              ),
              Padding(
                padding:EdgeInsets.all(15),
                child: isLoading?
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.height*0.04,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ):isFile?
                TextButton( 
                  style: TextButton.styleFrom(
                    backgroundColor: bgColor.withOpacity(0.6),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height*0.02,
                    ),
                  ),
                  onPressed: (){
                    setState(() {
                      isLoading = true;
                  });
                  
                  Timer(Duration(seconds: 1), (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context)=> EditImage(widget.file, bl, br, tl, tr, 
                      height, width, imagePixelSize, widget.animatedListKey)
                    ));
                  }); 
                },
                ):
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.height*0.04,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<File?> chooseImage(ImageSource src) async{
    try{
      //File holds path and XFile wraps the bytes of selected file
      final XFile? pickedImage = await _picker.pickImage(source: src);
      if(pickedImage != null){
        img = File(pickedImage.path);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder:(context)=> ScanImage(img!, widget.animatedListKey)));
      }     
    }
    on PlatformException catch(e){
      print('Failed to pick image: $e');
    }    
  }


}




