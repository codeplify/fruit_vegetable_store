import 'package:flutter/material.dart';
import 'screen/product-details.dart';
import 'model/product.dart';
import 'screen/shopping-cart.dart';
import 'animation/transition.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final List<Product> products = List<Product>();
  MyApp(); //like constructor

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
        home: new HomeScreen()
    );
  }
}


class HomeScreen extends StatelessWidget{

  final List<Product> products = List<Product>();
    HomeScreen();

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
  }
}


