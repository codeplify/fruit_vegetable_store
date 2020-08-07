import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

//no time to clean
void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;
  final List<Product> products = List<Product>();

  MyApp({Key key, @required this.items}); //like constructor

  @override
  Widget build(BuildContext context){

    return MaterialApp(
        title: "AppleStore App",
        initialRoute: '/',
        routes: {
          '/cart': (context) => ShoppingCart(),
        },
        theme: ThemeData(
          primarySwatch: Colors.red
        ),
        home: new HomeScreen(items: null)
    );
  }
}

class CheckoutScreen extends StatelessWidget{
    @override
    Widget build(BuildContext context) {
        return new Scaffold(

            appBar: AppBar(title: Text("Payment")),
            body:
            Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                Column(
                  children: [
                    Image.asset('assets/images/payment_cards.jpg', width: 300, height: 70),
                    TextFormField(
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          labelText: 'Card Number',
                          suffixIcon: Padding(padding: EdgeInsets.all(0.0),child: Icon(Icons.credit_card),),
                      ),
                    ),
                    TextFormField(
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Expiry Date',
                        suffixIcon: Padding(padding: EdgeInsets.all(0.0),child: Icon(Icons.date_range),),
                      ),
                    ),
                    TextFormField(
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          labelText: 'CVV Code',
                        suffixIcon: Padding(padding: EdgeInsets.all(0.0),child: Icon(Icons.credit_card),),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, SlideRightRoute(page:MyApp()));
                        clearOrder();
                      },
                      child: Text("Process Order"),
                      color: Colors.red,
                      textColor: Colors.white,
                    ),
                  ],


                ),

            )



        );
    }
}

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

class HomeScreen extends StatelessWidget{

  final List<ListItem> items;
  final List<Product> products = List<Product>();
    HomeScreen({Key key, @required this.items});



    @override
    Widget build(BuildContext context){

    products.clear();
    products.add(Product(1,"Brocoli",50.0,"p1.jpg"));
    products.add(Product(2,"Cabbage",30.0,"p5.jpg"));
    products.add(Product(3,"Eggplant",8.0,"p6.jpg"));
    products.add(Product(4,"Carrots",20.0,"p3.jpg"));
    products.add(Product(5,"Banana",10.0,"p2.jpg"));
    products.add(Product(6,"Grapes",10.0,"p4.jpg"));

        return new Scaffold(

          appBar: AppBar(title: Text("Fruit/Vegetable Store"),
            actions:[
               IconButton(
                  icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCart()));
                    },
                ),
            ],
          ),

          body: ListView.builder(
          itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];

              return ListTile(
                title: Text("" + item.description),
                subtitle: Text("AED " + item.price.toString()),
                leading: Image.asset('assets/images/' + item.image,  width: 100, height: 150),
                onTap: () => onTapped( item, context),

              );
            },
          ),

          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.sort),
              onPressed: (){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new ShoppingCart()),
                  );
              },

          ),
        );
    }


  void onTapped(Product prod, context){
    Navigator.push(context, ScaleRoute(page:ProductDetails(prod.id.toString(), prod.description.toString(),prod.price.toString(),prod.image)));
   // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(prod.id.toString(), prod.description.toString(),prod.price.toString(),prod.image)));
  }

  void onTappeCart(context){
    debugPrint("call route");
    Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartRoute()));
  }
}


class Details extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      return MaterialApp(
        
      );
  }

}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

class MessageItem implements ListItem {
  final String sender;
  final String body;
  MessageItem(this.sender, this.body);
  Widget buildTitle(BuildContext context) => Text(sender);
  Widget buildSubtitle(BuildContext context) => Text(body);
}

//model
class Product{
  Product(this.id, this.description , this.price, this.image);
  int id;
  String description;
  double price;
  String image;
}

class Order{
  Order(this.id, this.description, this.price, this.quantity, this.total);
  String id;
  String description;
  String price;
  String quantity;
  String total;
}



class ShoppingCartRoute extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart"),),
      body:

      Text(" Orders: ")
      ,
    );
    throw UnimplementedError();
  }
}

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


class ProductDetails extends StatefulWidget {
  final String textId;
  final String textName;
  final String amount;
  final String image;
  ProductDetails(this.textId, this.textName, this.amount, this.image);

  @override
  _ProductDetailsState createState() => _ProductDetailsState(textId, textName, amount, image);

}

//transition animation ->
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}

class _ProductDetailsState extends State<ProductDetails> {

  final String textId;
  final String textName;
  final String amount;
  final String image;

  int count  = 1;

  _ProductDetailsState(this.textId, this.textName, this.amount, this.image);

  final textController = TextEditingController();

  textListener(){
      //debugPrint("listener " + textController.text);
      //textController.text = "1";
  }

  @override
  void initState() {
    super.initState();
    //textController.addListener(textListener);
  }

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //textController.text = "1";
    textController.text = "1";
    return Scaffold(
      appBar: AppBar(title: Text(textName),),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            child: Row(
              children:[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/' + image, width: 600, height: 240, fit: BoxFit.cover,),
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(textName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Text("AED " + amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Container(
                        child: Text("Botanically, fruits and vegetables are classified depending on which part of the plant they come from. A fruit develops from the flower of a plant.."),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            child: Text("Quantity"),
          )
          ,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  FlatButton(child: Text("-",

                  style: TextStyle(
                      fontSize: 35.0,
                      height: 2.0,
                      color: Colors.black
                  )),
                    onPressed: (){
                      var q = count--;
                      textController.text = q.toString();
                    },
                  ),
                  Container(
                      width: 100.0,
                      child: TextFormField(
                          controller: textController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              height: 2.0,
                              color: Colors.black
                          )
                      )
                  ),
                  FlatButton(child: Text("+",
                  style: TextStyle(
                      fontSize: 35.0,
                      height: 2.0,
                      color: Colors.black,
                  )),onPressed: (){
                      var qty = (int.parse(textController.text) + 1);
                      var q = count ++;
                      textController.text = q.toString();
                      debugPrint(q.toString());

                  },)
              ],
            ),

          ),

          Container(
            child: FlatButton(
              onPressed: () {
                String order = "id:" + textId + ",name:" + textName + ", quantity:"+ textController.text +" ,amount:" + amount + "|";
                var o = saveOrder(order);
                debugPrint("order");
              },
              child: Text(" Add to Cart "),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )],
      ),
    );
  }
}


