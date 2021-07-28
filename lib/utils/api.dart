import 'package:http/http.dart';
import 'package:shopping_app/utils/database.dart';

class ApiRequests {
  final String url = 'https://fakestoreapi.com/products';

  Future<Response> getData() async {
    final String url = 'https://fakestoreapi.com/products';
    return await get(Uri.parse(url));
  }
}

class ProductData {
  String? id;
  String? title, desc;
  double? price;
  String? category;

  DatabaseService ds = DatabaseService();

  ProductData({this.id, this.title, this.desc, this.price, this.category});

  // Future<void> get() async {
  //   await ds.getUserData();
  //   cart = ds.cart;
  //   fav = ds.fav;
  //   print("hoooray");
  //   print(ds.cart);
  //   print(ds.fav);
  //   return null;
  // }
}
