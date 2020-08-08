import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../screen/checkout-screen.dart';
import '../model/order.dart';
import '../persistence/shared-preferences.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();

}

class _ShoppingCartState extends State<ShoppingCart> {
  String _order = "";
  @override
  void initState(){
    getOrder().then(updateOrder);
    super.initState();
  }


  void updateOrder(String order){
    setState(() {
      this._order = order;
    });
  }

  List<Order> ord = new List<Order>();
  Map map = new Map<int, String>();



  //Text(" Orders: $_order"),
  @override
  Widget build(BuildContext context) {
    ord.clear();

    //todo:- get this from shared preference
    String order = _order;

    debugPrint(order);

    List<String> orderList = order.split("|");
    double orderTotal = 0.0;
    for(String o in orderList){
      List<String> ol = o.split(",");

      Order order = new Order("","","","","");

      for(String ox in ol){
        debugPrint(ox);

        if(ox.contains("id")){
          order.id = ox.split(":")[1];
        }

        if(ox.contains("name")){
          order.description = ox.split(":")[1];
        }


        if(ox.contains("quantity")){
          order.quantity = ox.split(":")[1];
        }


        if(ox.contains("amount")){
          double totalD = double.parse(ox.split(":")[1]) * double.parse(order.quantity);
          orderTotal = orderTotal + totalD;
          order.price = ox.split(":")[1];
          order.total = totalD.toString();
        }

      }

      ord.add(order);
    }

    return Scaffold(
        appBar: AppBar(title: Text("Shopping Cart"),),

        body:
        Column(
            children:[
              Image.asset('assets/images/cart.jpg', width: 600, height: 150, fit: BoxFit.cover,)
              ,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                Table(

                  border: TableBorder.all(color: Colors.black , width: 1, style: BorderStyle.none),
                  children: [
                    TableRow(children: [
                      TableCell(child: Text("Item",style: TextStyle(
                          fontSize: 15.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                      TableCell(child: Text("Quantity",style: TextStyle(
                          fontSize: 15.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                      TableCell(child: Text("Amount",style: TextStyle(
                          fontSize: 15.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                      TableCell(child: Text("Total",style: TextStyle(
                          fontSize: 15.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                    ]),


                    for(var v in ord) TableRow(children: [
                      TableCell(child: Text("" + v.description),),
                      TableCell(child: Text("" + v.quantity),),
                      TableCell(child: Text("" + v.price.toString()),),
                      TableCell(child: Text("" + v.total.toString()),),
                    ]
                    ),

                    TableRow(children: [
                      TableCell(child: Text(""),),
                      TableCell(child: Text(""),),
                      TableCell(child: Text("Total: AED", style: TextStyle(
                          fontSize: 17.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                      TableCell(child: Text("" + orderTotal.toString(), style: TextStyle(
                          fontSize: 17.0,
                          height: 2.0,
                          color: Colors.black
                      )),),
                    ]),

                  ],
                ),
              ),

              Container(
                child: FlatButton(

                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));

                  },
                  child: Text("Check Out"),
                  color: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ]
        )



    );
  }
}
