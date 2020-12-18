import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:login_flutter/pages/inicialPage.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('PHP Login'),
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: MyApp(),
      ),
    ),
    routes: <String, WidgetBuilder>{
      '/inicialPage': (BuildContext context) => new Inicial(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool signin = true;

  TextEditingController namectrl, emailctrl, passctrl;

  bool processing = false;
  var teste = "";

  @override
  void initState() {
    super.initState();
    namectrl = new TextEditingController();
    emailctrl = new TextEditingController();
    passctrl = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Icon(Icons.account_circle, size: 200),
          boxUi(),
        ],
      ),
    );
  }

  void changeState() {
    if (signin) {
      setState(() {
        signin = false;
      });
    } else
      setState(() {
        signin = true;
      });
  }

  void registerUser() async {
    setState(() {
      processing = true;
    });

    final response =
        await http.post("http://selfped.ml/api_flutter/signup.php", body: {
      "email": emailctrl.text,
      "name": namectrl.text,
      "pass": passctrl.text,
    });

    var _res = jsonDecode(response.body);

    /*var url = "http://192.168.0.105/api_flutter/signup.php";
    var data = {
      'email': emailctrl.text,
      'name': namectrl.text,
      'pass': passctrl.text,
    };
    var res = await http.post(url, body: data);
    var res2 = res.toString();*/

    if (_res == "essa conta ja existe") {
      Fluttertoast.showToast(
          msg: "conta existe, por favor faça login",
          toastLength: Toast.LENGTH_SHORT);
    } else if (_res == "essa conta nao existe") {
      Fluttertoast.showToast(
          msg: "conta criada", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: "Error", toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  void userSignIn() async {
    setState(() {
      processing = true;
    });

    var url = "http://selfped.ml/api_flutter/signup.php";
    var data = {
      'email': emailctrl.text,
      'pass': passctrl.text,
    };
    var res2 = await http.post(url, body: data);

    if (json.decode(res2.body) == "Conta nao existe") {
      Fluttertoast.showToast(
          msg: "Conta não existe, Por favor faça uma cadastro",
          toastLength: Toast.LENGTH_SHORT);
    } else if (jsonDecode(res2.body) == "false") {
      Fluttertoast.showToast(
          msg: "Pass incorreto!", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: "Foi", toastLength: Toast.LENGTH_SHORT);
      Navigator.pushReplacementNamed(context, '/inicialPage');
    }
    setState(() {
      processing = false;
    });
  }

  Widget boxUi() {
    return Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => changeState(),
                    child: Text(
                      "SIGN IN",
                      style: GoogleFonts.varelaRound(
                        color: signin == true ? Colors.blue : Colors.grey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => changeState(),
                    child: Text(
                      "SIGN UP",
                      style: GoogleFonts.varelaRound(
                        color: signin != true ? Colors.blue : Colors.grey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              signin == true ? signInUi() : signUpUi(),
            ],
          ),
        ));
  }

  Widget signInUi() {
    return Column(
      children: <Widget>[
        TextField(
          controller: emailctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
            ),
            hintText: 'email',
          ),
        ),
        TextField(
          controller: passctrl,
          obscureText: false,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            hintText: 'password',
          ),
        ),
        SizedBox(height: 10.0),
        MaterialButton(
            onPressed: () => userSignIn(),
            child: processing == false
                ? Text(
                    'Sing In',
                    style: GoogleFonts.varelaRound(
                        fontSize: 18.0, color: Colors.blue),
                  )
                : CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ))
      ],
    );
  }

  Widget signUpUi() {
    return Column(
      children: <Widget>[
        TextField(
          controller: namectrl,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
            ),
            hintText: 'name',
          ),
        ),
        TextField(
          controller: emailctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
            ),
            hintText: 'email',
          ),
        ),
        TextField(
          controller: passctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            hintText: 'password',
          ),
        ),
        SizedBox(height: 10.0),
        MaterialButton(
            onPressed: () => registerUser(),
            child: processing == false
                ? Text(
                    'Sing Up',
                    style: GoogleFonts.varelaRound(
                        fontSize: 18.0, color: Colors.blue),
                  )
                : CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  )),
      ],
    );
  }
}
