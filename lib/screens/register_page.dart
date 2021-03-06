import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v_com/screens/login_page.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/widgets/custom_btn.dart';
import 'package:v_com/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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


  Future<String> _createAccount() async{
     try{
       await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: _registerEmail, password: _registerPassword);
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
      _registerFormLoadin = true;
    });


    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoadin = false;
      });
    }else{
      Navigator.pop(context);
    }
  }

  bool _registerFormLoadin = false;

  String _registerEmail = "";
  String _registerPassword = "";

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
                child: Text("Create A New Account",
                  textAlign: TextAlign.center,
                  style: constants.boaldheading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hinttext: "Email..",
                    onChanged: (value){
                      _registerEmail = value;
                    },
                    onSubmitted: (value){
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hinttext: "Password..",
                    onChanged: (value){
                      _registerPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomBtn(
                    text: "Create New Account",
                    onPressed: (){
                      _submitForm();
                    },
                    isLoading: _registerFormLoadin,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomBtn(
                  text: "Login",
                  onPressed: (){
                    Navigator.pop(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ),
                    );
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
