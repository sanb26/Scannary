import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_size_getter/image_size_getter.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/screens/cropPainter.dart';

class CropImage extends StatefulWidget {
  
  File file;
  CropImage(this.file, {Key? key}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {

  final GlobalKey key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late double width, height;
  late Size imagePixelSize;
  bool isFile = false;
  late Offset tl, tr, bl, br;
  bool isLoading = false;
  MethodChannel channel = new MethodChannel('opencv');

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
              child: bottomSheet(),
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
              // TextButton(
              //   child: Text(
              //     'Retake', 
              //     style: GoogleFonts.poppins(
              //       color: Colors.white.withOpacity(0.6),
              //       fontSize: MediaQuery.of(context).size.height*0.02,
              //     ),
              //   ),
              //   onPressed: (){}, 
              // ),
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
                  double tl_x = (imagePixelSize.width / width) * tl.dx;
                  double tr_x = (imagePixelSize.width / width) * tr.dx;
                  double bl_x = (imagePixelSize.width / width) * bl.dx;
                  double br_x = (imagePixelSize.width / width) * br.dx;

                  double tl_y = (imagePixelSize.height / height) * tl.dy;
                  double tr_y = (imagePixelSize.height / height) * tr.dy;
                  double bl_y = (imagePixelSize.height / height) * bl.dy;
                  double br_y = (imagePixelSize.height / height) * br.dy;

                  Timer(Duration(seconds: 1), ()async {
                    var bytesArray = await channel.invokeMethod('convertToGray', {
                      'filePath': widget.file.path,
                      'tl_x': tl_x,
                      'tl_y': tl_y,
                      'tr_x': tr_x,
                      'tr_y': tr_y,
                      'bl_x': bl_x,
                      'bl_y': bl_y,
                      'br_x': br_x,
                      'br_y': br_y,
                    });
                    Navigator.of(context).pop([bytesArray, tl_x, tl_y, tr_x, tr_y,
                    bl_x, bl_y, br_x, br_y]);
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

}