import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scannary_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scannary_app/provider/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor1,bgColor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 50, 40, 10),
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              Flexible(
                flex: 3,
                child: Text(
                  "Scannary",
                  style:GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize:  MediaQuery.of(context).size.height * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                flex: 1,
                child:ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,), 
                label: Text(
                  'Sign Up with Google',
                  style: GoogleFonts.poppins(
                    letterSpacing: 0.168,
                  ),
                ),
                onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();

                }, 
              ),
              ),
            ],
          ),
        )
      ),
    );
  }
}


