import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/screens/drawer.dart';
import 'package:scannary_app/screens/scanImage.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:scannary_app/screens/ocr.dart';
import 'package:scannary_app/screens/viewPdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? EmptyFile;
  final ImagePicker _picker = ImagePicker();
  File? img;
  var files;
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
            icon: FaIcon(FontAwesomeIcons.textWidth, size: MediaQuery.of(context).size.height*0.03 ,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Ocr()),);
            },
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
      body:
          // child: FutureBuilder<Directory>(
          //     future: getExternalStorageDirectory(), builder: _buildDirectory)
      //   child: ListView.builder(
      // padding: const EdgeInsets.all(16.0),
      //   itemCount: _files.length,
      //   itemBuilder: (context, i) {
      //     return Text(_files.elementAt(i).path);
      //   })
      //   child: Text("Display pdfs here")

      FutureBuilder<Directory?>(
          future: getPDFFromStorage(), builder: _buildDirectory)
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

  Future<Directory?> getPDFFromStorage()async{
    var dir = await getExternalStorageDirectory();
    // var _files = dir!.listSync(recursive: true, followLinks: false);
    return dir;
  }


}

class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({required this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold( //view PDF
        appBar: AppBar(
          title: Text(pathPDF.substring(64)),
          backgroundColor: bgColor2,
        ),
        path: pathPDF
    );
  }
}



void shareDocument(String pdfPath) async {
  await FlutterShare.shareFile(title: "pdf", filePath: pdfPath);
}

final leftSection = Container(
  child: const CircleAvatar(
    backgroundImage: AssetImage("assets/logo.png"),
    backgroundColor: Colors.lightGreen,
    radius: 24.0,
  ),
);

final middleSection = Container(
  width: 200,
  child: Column(
    children: const <Widget>[
      Text("Name"),
      Text("Hi whatsup?"),
    ],
  ),
);

final rightSection = Container(
  color: Colors.blue,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: const <Widget>[
      Text("9:50",
        style: TextStyle(
            color: Colors.lightGreen,
            fontSize: 12.0),),
      CircleAvatar(
        backgroundColor: Colors.lightGreen,
        radius: 10.0,
        child: Text("2",
          style: TextStyle(color: Colors.white,
              fontSize: 12.0),),
      )
    ],
  ),
);

Widget _buildDirectory(
    BuildContext context, AsyncSnapshot<Directory?> snapshot) {
  Text text = const Text('');
  Directory dir;
  List<FileSystemEntity> _files = [];
  if (snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasError) {
      text = Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      dir = Directory(snapshot.data!.path);
      text = Text('path: ${dir.path}');
      _files = dir.listSync(recursive: true, followLinks: false);
    } else {
      text = const Text('path unavailable');
    }
  }
  if (null != _files) {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _files.length,
        itemBuilder: (context, i) {
          return Center(
            child: Card(
              color: Colors.blueGrey,
              elevation: 3,
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
              child: InkWell(
                onTap: () async{
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ViewPDF(pathPDF:_files.elementAt(i).path);}));
                //ByteData bytes = await rootBundle.load(_files.elementAt(i).path)  ;
                //File EmptyFile = File(_files.elementAt(i).path+'.pdf');
                //OpenFile.open(_files.elementAt(i).path+'.pdf');
                //print(_files.elementAt(i).path+'.pdf');
                // File file = File.fromUri(Uri.parse(_files.elementAt(i).path));
                // print(file.toString());
                // PDFDocument doc = await PDFDocument.fromFile(file);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => viewPdf(doc: doc)),);
                },

                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                      _files.elementAt(i).path.substring(64),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.share, color: Colors.greenAccent),
                              onPressed: () {
                                print("tapped");
                                shareDocument(_files.elementAt(i).path);
                              },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.textWidth, color: Colors.greenAccent),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              ),
            ),
          );
          return TextButton(onPressed: ()async{
            print("Hello");
            File file = File.fromUri(Uri.parse(_files.elementAt(i).path));
            print(file.toString());
            PDFDocument doc = await PDFDocument.fromFile(file);
            Navigator.push(context, MaterialPageRoute(builder: (context) => viewPdf(doc: doc)),);
          }, child: Text(_files.elementAt(i).path));
        });
  } else {
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }
}

