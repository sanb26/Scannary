import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scannary_app/constants.dart';
import 'package:scannary_app/loading.dart';
import 'package:scannary_app/screens/home.dart';
import 'package:scannary_app/screens/signIn.dart';


//Wrapper class is listening for auth Changes

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bgColor,
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loading();
        }
        else if(snapshot.hasData){
          return const HomePage();
        }
        else if(snapshot.hasError){
          return const Center(child: Text('Something went wrong!'),);
        }
        else{
          return const SignIn();
        }      
      }
    ),
  );
}