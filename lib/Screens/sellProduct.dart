import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:flutter/services.dart';

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
  String? category = null;
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

  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  bool loading = false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: loading
          ? Loading()
          : Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Product Details",
                  style: TextStyle(
                      foreground: Paint()..shader = txtgradient1,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 10,
              ),
              body: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
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
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 280,
                                      height: 280,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text("Add product image"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                              child: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red),
                                          ))
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
                              //filled: true,
                              //fillColor: Colors.pink.shade50,
                              labelText: "Title",
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.pink[400]!,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
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
                            minLines: 5,
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
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.pink[400]!,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              prefixText: "\$ ",
                              labelText: "Price",
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.pink[400]!,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              disabledBorder: InputBorder.none,
                            ),
                            validator: (text) {
                              if (text == null ||
                                  text.isEmpty ||
                                  text.trim().isEmpty ||
                                  double.parse(text.trim()) == 0)
                                return "Enter the proper amount!";
                              return null;
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                focusColor: Colors.teal[100],
                                value: category,
                                hint: Text("Product Category"),
                                elevation: 5,
                                dropdownColor: Colors.teal[100],
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
                                // hint: Text(
                                //   "Product Category",
                                //   style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                onChanged: (value) {
                                  setState(() {
                                    category = value;
                                    product!.category = category;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // ElevatedButton(
                          //     onPressed: () async {
                          //       if (_image != null) if (_formkey.currentState!
                          //           .validate()) {
                          //         setState(() {
                          //           loading = true;
                          //         });
                          //         product!.image = await ds.uploadImage(_image);
                          //         await ds.addProduct(product);
                          //         Navigator.pop(context);
                          //       } else
                          //         setState(() {
                          //           error =
                          //               "Upload a product image for customers to see!";
                          //         });
                          //     },
                          //     child: Text("Sell Item")),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(80),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(80),
                              splashColor: Colors.pink,
                              onTap: () async {
                                if (_image == null)
                                  setState(() {
                                    error = "Upload a product image!";
                                  });
                                if (_formkey.currentState!.validate() &&
                                    _image != null) {
                                  setState(() {
                                    loading = true;
                                  });
                                  product!.image = await ds.uploadImage(_image);
                                  await ds.addProduct(product);
                                  Navigator.pop(context);
                                }
                              },
                              child: Ink(
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: myGradient,
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                child: Container(
                                  color: Colors.transparent,

                                  constraints: const BoxConstraints(
                                      minWidth: 88.0,
                                      minHeight:
                                          36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Sell Item',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.sell_outlined,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
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
