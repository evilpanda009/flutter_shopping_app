import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formkey = GlobalKey<FormState>();

  bool obscure = true;
  Color txtCol = Colors.white;
  String name = "";
  String email = "";
  String pass = "";
  String pass1 = "";
  String error = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Splash()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                txtCol = Colors.white;
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                color: Colors.white,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/blue_backg.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 80, 20, 10),
                          padding: EdgeInsets.all(10),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Register',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        fontFamily: "Roboto",
                                        color: Colors.blue,
                                        // shadows: [
                                        //   Shadow(
                                        //     color: Colors.black.withOpacity(0.3),
                                        //     offset: Offset(5, 5),
                                        //     blurRadius: 5,
                                        //   ),
                                        //]
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: txtCol.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(
                                            4, 4), // changes position of shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  margin: EdgeInsets.only(top: 50),
                                  child: TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty)
                                        return "This field cannot be empty";

                                      return null;
                                    },
                                    onChanged: (val) {
                                      name = val;
                                    },
                                    cursorColor: Colors.amber,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.tealAccent[700],
                                        size: 24,
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      disabledBorder: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.amber,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: txtCol.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(
                                            4, 4), // changes position of shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  margin: EdgeInsets.only(top: 50),
                                  child: TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty)
                                        return "This field cannot be empty";

                                      return null;
                                    },
                                    onChanged: (val) {
                                      email = val;
                                    },
                                    cursorColor: Colors.amber,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.tealAccent[700],
                                        size: 24,
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      disabledBorder: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.amber,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: txtCol.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(
                                            3, 3), // changes position of shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  margin: EdgeInsets.only(top: 50),
                                  child: TextFormField(
                                    onTap: () {
                                      setState(() {
                                        txtCol = Colors.grey[700]!;
                                      });
                                    },
                                    onChanged: (val) {
                                      pass = val;
                                    },
                                    validator: (text) {
                                      if (text!.length < 6)
                                        return "Password must 6+ characters";
                                      return null;
                                    },
                                    cursorColor: Colors.amber,
                                    obscureText: obscure,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.tealAccent[700],
                                      ),
                                      suffixIcon: IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            setState(() {
                                              obscure = !obscure;
                                            });
                                          },
                                          icon: obscure != true
                                              ? Icon(
                                                  Icons.visibility,
                                                  color: Colors.tealAccent[700],
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.tealAccent[700],
                                                  size: 20,
                                                )),
                                      contentPadding: EdgeInsets.all(5),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.tealAccent[700],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Material(
                                  elevation: 20,
                                  shadowColor: Colors.grey,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      pass1 = val;
                                    },
                                    cursorColor: Colors.amber,
                                    obscureText: true,
                                    validator: (text) {
                                      if (text!.length < 6)
                                        return "Password must 6+ characters";
                                      if (pass != pass1)
                                        return "Confirm password is different from password!";
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: "Confirm Password",
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.tealAccent[700],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.tealAccent[700],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.tealAccent[700],
                                      onPrimary: Colors.blue),
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic user =
                                          await _auth.signUp(email, pass);
                                      if (user != null) {
                                        dynamic add = await AddUser(name, email)
                                            .addUser();
                                        if (add != null) {
                                          dynamic signedInUser =
                                              await _auth.signIn(email, pass);
                                          if (signedInUser == null)
                                            setState(() {
                                              loading = false;
                                            });
                                          else {
                                            print(signedInUser);
                                            Navigator.popAndPushNamed(
                                                context, '/home');
                                          }
                                        } else
                                          setState(() {
                                            error = "User Registration failed";
                                          });
                                      } else
                                        setState(() {
                                          error = _auth.err;
                                        });
                                    }
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  error,
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
