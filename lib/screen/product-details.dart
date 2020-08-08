import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../persistence/shared-preferences.dart';

class ProductDetails extends StatefulWidget {
  final String textId;
  final String textName;
  final String amount;
  final String image;
  ProductDetails(this.textId, this.textName, this.amount, this.image);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(textId, textName, amount, image);
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
    return new Scaffold(
      appBar: AppBar(title: Text(textName),),
      body: Builder(
              builder: (context) =>
                Column(
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

                          _showSnack(context);

                      },
                      child: Text(" Add to Cart "),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )],
      ),
      ),
    );
  }

  void _showSnack(BuildContext context){
    final snackBar = SnackBar(
      content: Text('item is saved.'),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);

  }
}