import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatefulWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  _CartHistoryState createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  final user = AuthService().getUser().toString();

  final Stream<QuerySnapshot> history = FirebaseFirestore.instance
      .collection('carts')
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Past Orders",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: StreamBuilder(
          stream: history,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            if (snapshot.hasData) {
              var finalData = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Object?>> data = [];
              for (var doc in finalData) {
                if ((doc.data()! as Map<String, dynamic>)['user'] ==
                    user.toString()) {
                  data.add(doc);
                }
              }
              return Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 15,
                        thickness: 3,
                      );
                    },
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var document = data[index];
                      var date = DateTime.fromMillisecondsSinceEpoch(
                          document['timestamp']);
                      var formattedDate = DateFormat('dd-MM-yyyy').format(date);
                      var time = DateFormat.yMEd().add_jms().format(date);
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 30, right: 30),
                        child: SizedBox(
                          height: 270,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 9),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      time.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(
                                                height: 8,
                                                thickness: 1,
                                              );
                                            },
                                            itemCount:
                                                (data[index]['names'] as List?)!
                                                    .length,
                                            itemBuilder: (context, i) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: Wrap(children: [
                                                      Text(
                                                        document['names'][i],
                                                        //overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ]),
                                                  ),
                                                  Text("x " +
                                                      document['quantity'][i]
                                                          .toString() +
                                                      " "),
                                                  Text(
                                                    (document['prices'][i] *
                                                            document['quantity']
                                                                [i])
                                                        .toStringAsFixed(2),
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 21),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "\$ " +
                                              document['total']
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            return Empty();
          }),
    );
  }
}
