import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/register.dart';
import 'package:animations/animations.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool obscure = true;
  bool loading = false;
  Color txtCol = Colors.white;
  Color iconColor = Colors.tealAccent[700]!;
  String email = "";
  String password = "";
  String error = "";

  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  var myGradient1 = LinearGradient(
    colors: <Color>[Colors.orange[200]!, Colors.pink[100]!],
  );
  final Shader txtgradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return loading
        ? Splash()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Form(
                    key: _formkey,
                    child: Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height
                          : null,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.grey[50]
                          //gradient: myGradient1
                          // image: DecorationImage(
                          //   image: AssetImage(
                          //     "assets/blue_backg.jpg",
                          //   ),
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 80, 20, 10),
                              padding: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Login',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 40,
                                            foreground: Paint()
                                              ..shader = txtgradient1,

                                            //color: Colors.orange,
                                            // shadows: [
                                            //   Shadow(
                                            //     color: Colors.black54.withOpacity(0.3),
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
                                            color: Colors.grey[900]!
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(3,
                                                3), // changes position of shadow
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      margin: EdgeInsets.only(top: 50),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            email = val.trim();
                                          });
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor: Colors.amber,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.black54,
                                            size: 24,
                                          ),
                                          contentPadding: EdgeInsets.all(8),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.orange,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[900]!
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(3,
                                                3), // changes position of shadow
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      margin: EdgeInsets.only(top: 50),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                        cursorColor: Colors.orange,
                                        obscureText: obscure,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.black54,
                                          ),
                                          suffixIcon: IconButton(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onPressed: () {
                                                setState(() {
                                                  obscure = !obscure;
                                                });
                                              },
                                              icon: obscure != true
                                                  ? Icon(
                                                      Icons.visibility,
                                                      color: Colors.black54,
                                                      size: 20,
                                                    )
                                                  : Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.black54,
                                                      size: 20,
                                                    )),
                                          contentPadding: EdgeInsets.all(8),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 10),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "",
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          error,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(80),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(80),
                                        splashColor: Colors.pink,
                                        onTap: () async {
                                          if (email.isEmpty ||
                                              password.isEmpty) {
                                            setState(() {
                                              loading = false;
                                              error =
                                                  "One or more required fields is empty";
                                            });
                                          } else {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic user = await _auth.signIn(
                                                email, password);
                                            if (user == null) {
                                              setState(() {
                                                loading = false;
                                                error = _auth.err;
                                              });
                                            }
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
                                                Text('Login',
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
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: Text(
                                        'Dont have an Account?',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 700),
                                                  transitionsBuilder:
                                                      (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secanimation,
                                                          Widget child) {
                                                    animation = CurvedAnimation(
                                                        parent: animation,
                                                        curve:
                                                            Curves.easeInOut);
                                                    return ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                      alignment:
                                                          Alignment.center,
                                                    );
                                                  },
                                                  pageBuilder:
                                                      (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secanimation) {
                                                    return Register();
                                                  }));
                                        });
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.orange),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "- Or Sign In with -",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic user =
                                        await _auth.signInWithGoogle();

                                    print("==========================" +
                                        user.toString() +
                                        "=================================");

                                    if (user == null) {
                                      setState(() {
                                        loading = false;
                                        error =
                                            "Sign in failed, Check internet connection";
                                      });
                                    } else {
                                      dynamic add = await AddUser(
                                              user.displayName, user.email)
                                          .addUser();
                                    }
                                  }
                                  // setState(() {
                                  //   loading = false;
                                  // });
                                  ,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),

                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey[850]!
                                      //         .withOpacity(0.3),
                                      //     spreadRadius: 3,
                                      //     blurRadius: 5,
                                      //     offset: Offset(0,
                                      //         2), // changes position of shadow
                                      //   )
                                      // ],
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: AssetImage("assets/google.jpg"),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                    padding: EdgeInsets.all(8),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ClipPath(
                                  clipper: WaveClipperTwo(reverse: true),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          gradient: myGradient1))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
