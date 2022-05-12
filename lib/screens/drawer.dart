// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/provider/google_sign_in.dart';

class AppBarDrawer extends StatelessWidget {
  const AppBarDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Drawer(
      child: Material(
        color: bgColor2,
        child: ListView(
          children: [
            buildHeader(
              imageURL: user.photoURL!,
              name: user.displayName!,
              email: user.email!,
            ),
            const Divider(color: Colors.white70),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.infoCircle, color: Colors.white),
              title: Text(
                'About this App',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              onTap: (){},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.shareAlt, color: Colors.white),
              title: Text(
                'Share this App',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              onTap: (){},
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.white),
              title: Text(
                'Sign out',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              onTap: (){
                final provider = Provider.of<GoogleSignInProvider >(context, listen: false);
                provider.logout();
              },
            )
          ],
        ),
      ),
    );
  }
}

//buildHeader widget
Widget buildHeader({
  required String imageURL,
  required String name,
  required String email,
}){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Column(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageURL)),
        SizedBox(height: 20),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        Text(
          email,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
  ],
    ),
  );
}