
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getOrder() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String order = prefs.getString("order_items");
  return order;
}

Future<bool> clearOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("order_items", "");
  return prefs.commit();
}

Future<bool> saveOrder(String order) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getString("order_items") != null){

    String oldOrder = prefs.getString("order_items") + order;
    prefs.setString("order_items", oldOrder);

  }else{
    prefs.setString("order_items", order);
  }
  return prefs.commit();
}