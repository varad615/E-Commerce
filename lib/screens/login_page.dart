import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/widgets/custom_btn.dart';
import 'package:v_com/widgets/custom_input.dart';
import 'package:v_com/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    }  on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e){
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoadin = true;
    });


    String _loginInFeedback = await _loginAccount();
    if(_loginInFeedback != null) {
      _alertDialogBuilder(_loginInFeedback);

      setState(() {
        _loginFormLoadin = false;
      });}
  }

  bool _loginFormLoadin = false;

  String _loginEmail = "";
  String _loginPassword = "";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 24.0
                ),
                child: Text("Welcome \n Login to your account",
                textAlign: TextAlign.center,
                  style: constants.boaldheading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hinttext: "Email..",
                    onChanged: (value){
                      _loginEmail = value;
                    },
                    onSubmitted: (value){
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hinttext: "Password..",
                    onChanged: (value){
                      _loginPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomBtn(
                    text: "Login",
                    onPressed: (){
                      _submitForm();
                    },
                    isLoading: _loginFormLoadin,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomBtn(
                  text: "Create New Account",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RegisterPage()
                    ),);
                  },
                  outlinebtn: false,
                ),
              ),
            ], 
          ),
        ),
      ),
      );
  }
}
