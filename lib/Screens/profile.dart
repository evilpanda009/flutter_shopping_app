import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final DatabaseService ds = DatabaseService();
  final db = FirebaseFirestore.instance;
  late String name, email;
  bool loading = true;
  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  final Shader txtgradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  // String getName() {
  //   final userId = _auth.getUser();
  //   print(userId);
  //   db
  //       .collection('users')
  //       .doc(userId.toString())
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       return documentSnapshot.data();
  //     }
  //   });
  //   return "";
  // }
  @override
  void initState() {
    super.initState();
    var user = _auth.getUser().toString();

    db
        .collection('users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data());
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'].toString();
          email = data['email'].toString();
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Container(
              color: Color(0xfff3f0ec),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipPath(
                      clipper: WaveClipperTwo(),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.orange[400]!,
                          Colors.pink[300]!
                        ])),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                                //foreground: Paint()..shader = txtgradient1,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    //CircleAvatar(backgroundImage: _auth.,)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(
                          width: 10,
                        ),
                        Text(email, style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          icon: Icon(Icons.history),
                          label: Text("Order History",
                              style: TextStyle(fontSize: 15))),
                    ),

                    Container(
                      color: Colors.transparent,
                      width: 250,
                      margin: EdgeInsets.only(top: 150),
                      alignment: Alignment.center,
                      child: BouncingWidget(
                        duration: Duration(milliseconds: 250),
                        scaleFactor: 2,
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Logout"),
                                    content: Text("Are you sure?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();

                                            await AuthService().signOut();

                                            // for (int i = 0;
                                            //     i <=
                                            //         ds.cart!
                                            //             .length;
                                            //     i++) {
                                            //   await ds
                                            //       .removeFromCart(ds
                                            //           .cart![i]
                                            //           .toString());
                                            // }
                                          },
                                          child: Text(
                                            "Logout",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ));
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),

                          constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight:
                                  36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.power_settings_new_outlined,
                                  color: Colors.white),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Logout',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white)),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
