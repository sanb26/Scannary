// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/screens/cropImage.dart';

class EditImage extends StatefulWidget {
  File file;
  var imagePixelSize;
  double width;
  double height;
  Offset tl, tr, bl, br;
  GlobalKey<AnimatedListState> animatedListKey;

  EditImage(
      this.file,
      this.bl,
      this.br,
      this.tl,
      this.tr,
      this.height,
      this.width,
      this.imagePixelSize,
      this.animatedListKey);


  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

  TextEditingController fileNameController = TextEditingController();
  late PersistentBottomSheetController controller;
  final _focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MethodChannel channel = new MethodChannel('opencv');
  
  late double tl_x;
  late double tr_x;
  late double bl_x;
  late double br_x;
  late double tl_y;
  late double tr_y;
  late double bl_y;
  late double br_y;
  late double w;
  late double h;

  int index = 0;   //for bottom sheet
  int angle = 0;   //for rotation

  var bytes;
  var whiteboardBytes;
  var originalBytes;
  var grayBytes;

  bool isBottomOpened = false;
  bool isRotating = false;
  bool isGrayBytes = false;
  bool isOriginalBytes = false;
  bool isWhiteBoardBytes = false;

  String canvasType = "whiteboard";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initPlatformState();
    fileNameController.text = "Scan" + DateTime.now().toString();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        fileNameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: fileNameController.text.length,
        );
      }
    });
    tl_x = (widget.imagePixelSize.width / widget.width) * widget.tl.dx;
    tr_x = (widget.imagePixelSize.width / widget.width) * widget.tr.dx;
    bl_x = (widget.imagePixelSize.width / widget.width) * widget.bl.dx;
    br_x = (widget.imagePixelSize.width / widget.width) * widget.br.dx;

    tl_y = (widget.imagePixelSize.height / widget.height) * widget.tl.dy;
    tr_y = (widget.imagePixelSize.height / widget.height) * widget.tr.dy;
    bl_y = (widget.imagePixelSize.height / widget.height) * widget.bl.dy;
    br_y = (widget.imagePixelSize.height / widget.height) * widget.br.dy;

    w = widget.width;
    h = widget.height;
    convertToGray();
    BackButtonInterceptor.add(myInterceptor);
  }




  @override
  void dispose(){
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info){
    if(isBottomOpened){
      Navigator.of(context).pop();
      isBottomOpened = false;
    }
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Discard this Scan?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),            
            ),
            Divider(
              thickness: 2,
            ),
            Text(
              '\nThis will discard the scan you have captured. \nAre you sure?',
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.black,
              ), 
            ),
            onPressed:(){
              Navigator.of(context).pop();
            }, 
          ),
           OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            child: Text(
              'Discard',
              style: GoogleFonts.poppins(
                color: Colors.red,
              ), 
            ),
            onPressed:(){
              Navigator.pop(context);
              Navigator.pop(context);
              //return false;
            }, 
          ),
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                width: MediaQuery.of(context).size.width,
                color: bgColor2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // IconButton(
                        //   icon: Icon(Icons.clear, color: Colors.white),
                        //   onPressed: (){
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                        TextButton(
                          child: Text(
                            'Save as PDF',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height*0.02,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: (){},      
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[600],
                      ),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: fileNameController,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height*0.02,
                        ),
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),                    
                  ],
                ),
              ),
              bytes==null?
              Container():
              isRotating?
              Center(
                child: Container(
                  height: 150,
                  width: 100,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    ),
                  ),
                ),
              ):
              Center(
                child:Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height*0.60,
                    maxWidth: MediaQuery.of(context).size.width*0.85,
                  ),
                  child: Image.memory(bytes),
                ),
              ),
            ],
          ),
        ) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index,
        selectedItemColor: Colors.blue,
        onTap: (i) async{
          setState(() {
            index = i;
          });
          if(index == 0){
            if(isBottomOpened){
              isBottomOpened = false;
              Navigator.of(context).pop();
            }
            setState(() {
              isRotating = true;
            });
            Timer(Duration(seconds: 1), () async{
              bytes = await channel.invokeMethod('rotate', {"bytes": bytes});
            });

            Timer(Duration(seconds: 2), () async{
              if(angle == 360){
                angle =0;
              }
               angle = angle + 90;
               bytes = await channel.invokeMethod('rotateCompleted', {"bytes": bytes});
               setState(() {
                 bytes = bytes;
                 isRotating = false;
               });
            });
          }
          if (index == 1){
            if(isBottomOpened){
              isBottomOpened = false;
              Navigator.of(context).pop();
            }
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CropImage(widget.file),
            )).then((value) {
              if(value !=null){
                tl_x = value[1];
                tl_y = value[2];
                tr_x = value[3];
                tr_y = value[4];
                bl_x = value[5];
                bl_y = value[6];
                br_x = value[7];
                br_y = value[8];
                setState(() {
                  bytes = value[0];
                  isGrayBytes = false;
                  isOriginalBytes = false;
                  isWhiteBoardBytes = false;
                });
              }
            });
          }
          if (index == 2){
            if(isBottomOpened){
              Navigator.of(context).pop();
              isBottomOpened = false;
            } else{
              isBottomOpened = true;
              BottomSheet bottomSheet = BottomSheet(
                onClosing: () {},
                builder: (context) => filterBottomSheet(),
                enableDrag: true,
              );
              controller = scaffoldKey.currentState!.showBottomSheet((context) => bottomSheet);
            }
          }
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rotate_right,
              color: Colors.black,
            ), 
            label: "Rotate", 
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.crop,
              color: Colors.black,
            ), 
            label: "Crop", 
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter,
              color: Colors.black,
            ), 
            label: "Filters", 
          ),          
        ] ,
      ),
    );
  }

  Widget filterBottomSheet(){
    if(isOriginalBytes == false){
      grayandoriginal();
    }
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              if (originalBytes != null) {
                //print("original");
                Navigator.of(context).pop();
                isBottomOpened = false;
                canvasType = "original";
                Timer(Duration(milliseconds: 500), () {
                  angle = 0;
                  setState(() {
                    bytes = originalBytes;
                  });
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: 80,
                    margin: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: isOriginalBytes
                        ? Image.memory(
                            originalBytes,
                            fit: BoxFit.fill,
                            height: 120,
                          )
                        : Container(
                            height: 120,
                            child: Center(
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.black),
                                  )),
                            ),
                          )),
                Text("Original"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              //print("whiteboard");
              Navigator.of(context).pop();
              isBottomOpened = false;
              angle = 0;
              canvasType = "whiteboard";
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  bytes = whiteboardBytes;
                });
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: isWhiteBoardBytes
                      ? Image.memory(
                          whiteboardBytes,
                          fit: BoxFit.fill,
                          height: 120,
                        )
                      : Container(
                          height: 120,
                          child: Center(
                            child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                )),
                          ),
                        ),
                ),
                Text("Whiteboard"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              //print("gray");
              Navigator.of(context).pop();
              isBottomOpened = false;
              angle = 0;
              canvasType = "gray";
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  bytes = grayBytes;
                });
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 80,
                  margin: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: isGrayBytes
                      ? Image.memory(
                          grayBytes,
                          fit: BoxFit.fill,
                          height: 120,
                        )
                      : Container(
                          height: 120,
                          child: Center(
                            child: Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                )),
                          ),
                        ),
                ),
                Text("Grayscale"),
              ],
            ),
          )
        ],
      ),
    );
  }
  

  Future<dynamic> convertToGray() async {
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
    setState(() {
      bytes = bytesArray;
      whiteboardBytes = bytesArray;
    });
    return bytesArray;
  }
  
    Future<void> grayandoriginal() async {
    Future.delayed(Duration(seconds: 1), () {
      channel.invokeMethod('gray', {
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
      channel.invokeMethod('whiteboard', {
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
      channel.invokeMethod('original', {
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
    });
    Timer(Duration(seconds: 7), () {
      channel.invokeMethod('grayCompleted').then((value) {
        grayBytes = value;
        isGrayBytes = true;
      });
      channel.invokeMethod('whiteboardCompleted').then((value) {
        whiteboardBytes = value;
        isWhiteBoardBytes = true;
      });
      channel.invokeMethod('originalCompleted').then((value) {
        originalBytes = value;
        isOriginalBytes = true;
        if (isBottomOpened) {
          Navigator.pop(context);
          BottomSheet bottomSheet = BottomSheet(
            onClosing: () {},
            builder: (context) => filterBottomSheet(),
            enableDrag: true,
          );
          controller = scaffoldKey.currentState!.showBottomSheet((context) => bottomSheet);
        }
      });
    });
  }


}






