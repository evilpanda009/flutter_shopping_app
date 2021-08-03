import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    title = args['title'];
    desc = args['desc'];
    imageUrl = args['image'];
    category = args['category'];
    price = args['price'];
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
                            initialValue: title,
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
                            initialValue: desc,
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
                            focusColor: Colors.teal[100],
                            value: null,
                            hint: Text("Category"),
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
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          width: 300,
                                          height: 300,
                                          fit: BoxFit.fill,
                                        ))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: price.toString(),
                            decoration: InputDecoration(
                              labelText: "Price",
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
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
                                  if (_image != null)
                                    product!.image =
                                        await ds.uploadImage(_image);
                                  await ds.updateProduct(product);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Save Changes"))
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
