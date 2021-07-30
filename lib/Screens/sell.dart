import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  DatabaseService ds = DatabaseService();

  static var user = AuthService().getUser().toString();

  @override
  void initState() {
    //this.getCurrentUser();

    super.initState();
    user = AuthService().getUser().toString();
  }

  static User? _user;

  // _SellState() {
  // user = AuthService().getUser().toString();
  // }

  // void getCurrentUser() {
  //   _user = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     _user!.uid;
  //   });
  // calling setState allows widgets to access uid and access stream
  //}
  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .orderBy('id')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                tooltip: "Sell new product",
                onPressed: () {
                  Navigator.pushNamed(context, '/sellItem');
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: StreamBuilder(
          stream: productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              var finalData = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Object?>> data = [];
              for (var doc in finalData) {
                if ((doc.data()! as Map<String, dynamic>)['user'] ==
                    user.toString()) {
                  data.add(doc);
                }
              }

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/product',
                                arguments: data[index])
                            .then((value) => {setState(() {})});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    offset: Offset(0, 3))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                    height: 150,
                                    padding: EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8, right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/tag.jpg',
                                          image: data[index]['image'],
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        data[index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("\$ " +
                                          data[index]['price'].toString()),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Delete Product",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return Empty();
            // } else
            //   return Loading();
          }),
    );
  }
}

class SellItem extends StatefulWidget {
  const SellItem({Key? key}) : super(key: key);

  @override
  _SellItemState createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  DatabaseService ds = DatabaseService();
  String title = "";
  String desc = '';
  double price = 0;
  String? category;
  String imageUrl = "";
  XFile? _image;
  ProductData? product = ProductData();

  imgFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

    setState(() {
      _image = image;
    });
  }

  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  final _formkey = GlobalKey<FormState>();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: loading
          ? Loading()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (text) {
                              if (text == null ||
                                  text.isEmpty ||
                                  text.trim() == "")
                                return "This field cannot be empty";
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                title = val.trim();
                                product!.title = title;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Title",
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
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
                              enabledBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null ||
                                  text.isEmpty ||
                                  text.trim() == "")
                                return "This field cannot be empty";
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                desc = val.trim();
                                product!.desc = desc;
                              });
                            },
                            minLines:
                                6, // any number you need (It works as the rows for the textarea)
                            keyboardType: TextInputType.multiline,
                            maxLines: null,

                            decoration: InputDecoration(
                              hintText: "Describe your product here... ",
                              labelText: "Description",
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.all(15),
                              //border:
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                //borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DropdownButton<String>(
                            focusColor: Colors.white,
                            //value: category,
                            elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              'Men\'s Clothing',
                              'Women\'s Clothing',
                              'Kid\'s Stuff',
                              'Electronics',
                              'Home Accessories',
                              'Women\'s Accessories',
                              'Men\'s Accessories',
                              'Miscellaneous'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: Text(
                              "Product Category",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (value) {
                              setState(() {
                                category = value;
                              });
                            },
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(_image!.path),
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 300,
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text("Add product image")
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (text) {
                              if (text == null ||
                                  text.isEmpty ||
                                  text.trim().isEmpty ||
                                  double.parse(text.trim()) == 0)
                                return "Enter the proper amount!";
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                price = double.parse(val.trim());
                                product!.price = price;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  product!.image = await ds.uploadImage(_image);
                                  await ds.addProduct(product);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Sell Item"))
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
