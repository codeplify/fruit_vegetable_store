import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/main.dart';
import '../persistence/shared-preferences.dart';
import '../animation/transition.dart';

class CheckoutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: AppBar(title: Text("Payment")),
        body:
            Builder(
              builder: (context) =>
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
                                _showProgress(context);
                            },
                            child: Text("Process Order"),
                            color: Colors.red,
                            textColor: Colors.white,
                          ),
                        ],
                      ),

                )

            )
    );
  }

  void _showProgress(BuildContext context){
    AlertDialog alert = AlertDialog(
      title: Text("Order Success"),
      content: Text("your payment and order has been processed."),
      actions: <Widget>[
        FlatButton(
          child: Text("Okay"),
          onPressed: (){
            Navigator.push(context, SlideRightRoute(page:MyApp()));
            clearOrder();
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
            return alert;
        }
    );
  }



}