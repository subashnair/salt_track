import 'package:flutter/material.dart';
import 'package:salt_track/components/rounded_button.dart';
import 'package:salt_track/components/rounded_input_field.dart';
import 'package:salt_track/components/rounded_password_field.dart';
import 'package:salt_track/services/login_call.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  String username='';
  String password='';

  void Alert(String messageString)
  {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(messageString),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  void login(String cred) async {
    Tracking instance = Tracking();
    LoginResult _result = LoginResult();

    try {
        _result = await instance.getLogin(cred);
        if (_result.Success)
        Navigator.pushReplacementNamed(context, '/tracker', arguments:
            {
              'success': _result.Success,
              'message': _result.Message,
              'userid': _result.UserID
            }
        ) as bool;
        else Alert('Login Error');
    }
    catch(e) { }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(title: Text('salt-fulfil'),),

      backgroundColor: Colors.cyan,
      body:
     SingleChildScrollView(
      child:
      Center(
         child: Container(
          decoration: BoxDecoration(
            /*gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.cyan,
                Colors.blueAccent,
              ],
            ),*/
            image: DecorationImage(
              image: AssetImage('assets/salt-logo.png'),
              fit: BoxFit.fitWidth,
            ),
          ),

          child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
         /*   Text(
              "Login In",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),*/
           SizedBox(height: size.height * 0.10),
            Text('RHS Logistics',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.indigo),),
            Text('Omnichannel Platform',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ,color: Colors.white),),
            SizedBox(height: size.height * 0.35),
            RoundedInputField(
              hintText: "User Name",
              onChanged: (value) {
                username = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                login('$username/$password');
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
     )
      ),
    )
    );
  }
}

