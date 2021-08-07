import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  DatabaseService ds = DatabaseService();
  String title = "";
  String desc = '';
  double price = 0;
  String? category = null;
  String imageUrl = "";
  XFile? _image = null;
  ProductData? product = ProductData();
  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  final Shader txtgradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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

  late DocumentSnapshot args;

  bool loading = false;
  String? newcategory = null;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    title = args['title'];
    desc = args['desc'];
    imageUrl = args['image'];
    category = args['category'];
    price = double.parse(args['price'].toString());
    product!.id = args['id'].toString();

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
                  "Edit Product",
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
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: "assets/load.gif",
                                          image: imageUrl,
                                          width: 300,
                                          height: 300,
                                          fit: BoxFit.fill,
                                        ))),
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
                            initialValue: title,
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
                            initialValue: desc,
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
                            initialValue: price.toString(),
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
                                value: newcategory,
                                hint: Text(category!.toString()),
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
                                    newcategory = value;
                                    product!.category = newcategory;
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
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (_image != null)
                                    product!.image =
                                        await ds.uploadImage(_image);
                                  await ds.updateProduct(product);
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
                                      Text('Save Changes',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.save_alt, color: Colors.white)
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

              // Container(
              //   child: SingleChildScrollView(
              //     child: Form(
              //       key: _formkey,
              //       child: Padding(
              //         padding: const EdgeInsets.all(15.0),
              //         child: Column(
              //           children: [
              //             TextFormField(
              //               initialValue: title,
              //               validator: (text) {
              //                 if (text == null ||
              //                     text.isEmpty ||
              //                     text.trim() == "")
              //                   return "This field cannot be empty";
              //                 return null;
              //               },
              //               onChanged: (val) {
              //                 setState(() {
              //                   title = val.trim();
              //                   product!.title = title;
              //                 });
              //               },
              //               decoration: InputDecoration(
              //                 labelText: "Title",
              //                 labelStyle: TextStyle(
              //                   fontSize: 18,
              //                   color: Colors.grey,
              //                 ),
              //                 contentPadding: EdgeInsets.all(8),
              //                 border: InputBorder.none,
              //                 focusedBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10),
              //                   borderSide: BorderSide(
              //                     color: Colors.green,
              //                     width: 1.0,
              //                   ),
              //                 ),
              //                 enabledBorder: InputBorder.none,
              //                 errorBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10),
              //                   borderSide: BorderSide(
              //                     color: Colors.red,
              //                     width: 1.0,
              //                   ),
              //                 ),
              //                 disabledBorder: InputBorder.none,
              //               ),
              //             ),
              //             SizedBox(
              //               height: 30,
              //             ),
              //             TextFormField(
              //               initialValue: desc,
              //               validator: (text) {
              //                 if (text == null ||
              //                     text.isEmpty ||
              //                     text.trim() == "")
              //                   return "This field cannot be empty";
              //                 return null;
              //               },
              //               onChanged: (val) {
              //                 setState(() {
              //                   desc = val.trim();
              //                   product!.desc = desc;
              //                 });
              //               },
              //               minLines:
              //                   6, // any number you need (It works as the rows for the textarea)
              //               keyboardType: TextInputType.multiline,
              //               maxLines: null,

              //               decoration: InputDecoration(
              //                 hintText: "Describe your product here... ",
              //                 labelText: "Description",
              //                 alignLabelWithHint: true,
              //                 labelStyle: TextStyle(
              //                   fontSize: 18,
              //                   color: Colors.grey,
              //                 ),
              //                 contentPadding: EdgeInsets.all(15),
              //                 //border:
              //                 focusedBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10),
              //                   borderSide: BorderSide(
              //                     color: Colors.green,
              //                     width: 1.0,
              //                   ),
              //                 ),
              //                 enabledBorder: OutlineInputBorder(
              //                   //borderRadius: BorderRadius.circular(10),
              //                   borderSide: BorderSide(
              //                     color: Colors.green,
              //                     width: 1.0,
              //                   ),
              //                 ),
              //                 errorBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10),
              //                   borderSide: BorderSide(
              //                     color: Colors.red,
              //                     width: 1.0,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               height: 30,
              //             ),
              //             DropdownButton<String>(
              //               focusColor: Colors.teal[100],
              //               value: null,
              //               hint: Text("Category"),
              //               elevation: 5,
              //               dropdownColor: Colors.teal[100],
              //               style: TextStyle(color: Colors.white),
              //               iconEnabledColor: Colors.black,
              //               items: <String>[
              //                 'Men\'s Clothing',
              //                 'Women\'s Clothing',
              //                 'Kid\'s Stuff',
              //                 'Electronics',
              //                 'Home Accessories',
              //                 'Women\'s Accessories',
              //                 'Men\'s Accessories',
              //                 'Miscellaneous'
              //               ].map<DropdownMenuItem<String>>((String value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: Text(
              //                     value,
              //                     style: TextStyle(color: Colors.black),
              //                   ),
              //                 );
              //               }).toList(),
              //               // hint: Text(
              //               //   "Product Category",
              //               //   style: TextStyle(
              //               //       color: Colors.black,
              //               //       fontSize: 14,
              //               //       fontWeight: FontWeight.w500),
              //               // ),
              //               onChanged: (value) {
              //                 setState(() {
              //                   category = value;
              //                 });
              //               },
              //             ),
              //             Center(
              //               child: GestureDetector(
              //                   onTap: () {
              //                     _showPicker(context);
              //                   },
              //                   child: _image != null
              //                       ? ClipRRect(
              //                           borderRadius: BorderRadius.circular(10),
              //                           child: Image.file(
              //                             File(_image!.path),
              //                             width: 300,
              //                             height: 300,
              //                             fit: BoxFit.fill,
              //                           ),
              //                         )
              //                       : ClipRRect(
              //                           borderRadius: BorderRadius.circular(10),
              //                           child: Image.network(
              //                             imageUrl,
              //                             width: 300,
              //                             height: 300,
              //                             fit: BoxFit.fill,
              //                           ))),
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //             TextFormField(
              //               initialValue: price.toString(),
              //               decoration: InputDecoration(
              //                 labelText: "Price",
              //                 labelStyle: TextStyle(
              //                   fontSize: 18,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //               validator: (text) {
              //                 if (text == null ||
              //                     text.isEmpty ||
              //                     text.trim().isEmpty ||
              //                     double.parse(text.trim()) == 0)
              //                   return "Enter the proper amount!";
              //                 return null;
              //               },
              //               keyboardType: TextInputType.number,
              //               onChanged: (val) {
              //                 setState(() {
              //                   price = double.parse(val.trim());
              //                   product!.price = price;
              //                 });
              //               },
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //             ElevatedButton(
              //                 onPressed: () async {
              //                   if (_formkey.currentState!.validate()) {
              //                     setState(() {
              //                       loading = true;
              //                     });
              //                     if (_image != null)
              //                       product!.image =
              //                           await ds.uploadImage(_image);
              //                     await ds.updateProduct(product);
              //                     Navigator.pop(context);
              //                   }
              //                 },
              //                 child: Text("Save Changes"))
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
    );
  }
}
