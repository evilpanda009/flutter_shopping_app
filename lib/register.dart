import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formkey = GlobalKey<FormState>();
  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  final Shader txtgradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.black, Colors.grey[400]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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
              //resizeToAvoidBottomInset: false,
              body: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/blue_backg.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: SingleChildScrollView(
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
                                    child: Text('Sign Up',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 40,
                                          fontFamily: "Roboto",
                                          foreground: Paint()
                                            ..shader = txtgradient,
                                          //color: Colors.black,
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
                                          offset: Offset(4,
                                              4), // changes position of shadow
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    margin: EdgeInsets.only(top: 50),
                                    child: TextFormField(
                                      validator: (text) {
                                        if (text == null || text.trim() == "")
                                          return "This field cannot be empty";

                                        return null;
                                      },
                                      onChanged: (val) {
                                        name = val.trim();
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
                                          Icons.person_outline,
                                          color: Colors.orange,
                                          size: 24,
                                        ),
                                        contentPadding: EdgeInsets.all(8),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          offset: Offset(4,
                                              4), // changes position of shadow
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    margin: EdgeInsets.only(top: 50),
                                    child: TextFormField(
                                      validator: (text) {
                                        if (text == null ||
                                            text.isEmpty ||
                                            text.trim().isEmpty)
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
                                          color: Colors.orange,
                                          size: 24,
                                        ),
                                        contentPadding: EdgeInsets.all(8),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          offset: Offset(3,
                                              3), // changes position of shadow
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    margin: EdgeInsets.only(top: 50),
                                    child: TextFormField(
                                      onTap: () {
                                        // setState(() {
                                        //   txtCol = Colors.grey[700]!;
                                        // });
                                      },
                                      onChanged: (val) {
                                        pass = val;
                                      },
                                      validator: (text) {
                                        if (text == null ||
                                            text.length < 6 ||
                                            text.trim().length < 6)
                                          return "Password must be 6+ characters";
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(' ')
                                      ],
                                      cursorColor: Colors.amber,
                                      obscureText: obscure,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.orange,
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
                                                    color: Colors.orange,
                                                    size: 20,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  )),
                                        contentPadding: EdgeInsets.all(5),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  TextFormField(
                                    onChanged: (val) {
                                      pass1 = val;
                                    },
                                    cursorColor: Colors.amber,
                                    obscureText: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(' ')
                                    ],
                                    validator: (text) {
                                      if (text == null ||
                                          text.length < 6 ||
                                          text.trim().length < 6)
                                        return "Password must be 6+ characters";
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
                                        color: Colors.orange,
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.orange,
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
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(80),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(80),
                                      splashColor: Colors.pink,
                                      onTap: () async {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic user =
                                              await _auth.signUp(email, pass);
                                          if (user != null) {
                                            dynamic add =
                                                await AddUser(name, email)
                                                    .addUser();
                                            if (add != null) {
                                              dynamic signedInUser = await _auth
                                                  .signIn(email, pass);
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
                                                error =
                                                    "User Registration failed";
                                              });
                                          } else
                                            setState(() {
                                              error = _auth.err;
                                            });
                                        }
                                      },
                                      child: Ink(
                                        width: 300,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: myGradient,
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                        child: Container(
                                          color: Colors.transparent,

                                          constraints: const BoxConstraints(
                                              minWidth: 88.0,
                                              minHeight:
                                                  36.0), // min sizes for Material buttons
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Register and Login',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                      color: Colors.white)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(Icons.login,
                                                  color: Colors.white)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //       primary: Colors.orange,
                                  //       onPrimary: Colors.blue),
                                  //   onPressed: () async {
                                  //     if (_formkey.currentState!.validate()) {
                                  //       setState(() {
                                  //         loading = true;
                                  //       });
                                  //       dynamic user =
                                  //           await _auth.signUp(email, pass);
                                  //       if (user != null) {
                                  //         dynamic add =
                                  //             await AddUser(name, email)
                                  //                 .addUser();
                                  //         if (add != null) {
                                  //           dynamic signedInUser =
                                  //               await _auth.signIn(email, pass);
                                  //           if (signedInUser == null)
                                  //             setState(() {
                                  //               loading = false;
                                  //             });
                                  //           else {
                                  //             print(signedInUser);
                                  //             Navigator.popAndPushNamed(
                                  //                 context, '/home');
                                  //           }
                                  //         } else
                                  //           setState(() {
                                  //             error =
                                  //                 "User Registration failed";
                                  //           });
                                  //       } else
                                  //         setState(() {
                                  //           error = _auth.err;
                                  //         });
                                  //     }
                                  //   },
                                  //   child: Text(
                                  //     'Register and Login',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // ),
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
            ),
          );
  }
}
