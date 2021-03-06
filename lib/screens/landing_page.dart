import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/screens/home_page.dart';
import 'package:v_com/screens/login_page.dart';

class Landingpage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamsSapshot){
              if (streamsSapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamsSapshot.error}"),
                  ),
                );
              }

              if(streamsSapshot.connectionState == ConnectionState.active){

                User _user = streamsSapshot.data;

                if(_user == null){
                  return LoginPage();
                }else{
                  return HomePage();
                }
              }

              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication..."),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text("Initialization app...."),
          ),
        );
      },
    );
  }
}
