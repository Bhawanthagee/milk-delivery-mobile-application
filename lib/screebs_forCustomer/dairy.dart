import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noyan_app/screebs_forCustomer/pay.dart';

class DairyProducts extends StatefulWidget {
  @override
  _DairyProductsState createState() => _DairyProductsState();
}

class _DairyProductsState extends State<DairyProducts> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73AEF5),
              Color(0xFF61A4F1),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 28.0, left: 10, right: 10, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                        'assets/logos/milkPanda.png',
                      ))),
                    ),
                    Center(
                      child: Text(
                        'MILK PANDA',
                        style: GoogleFonts.chelaOne(
                            color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                width: double.infinity,
                color: Colors.yellowAccent,
                margin: EdgeInsets.only(left: 25, right: 25),
              ),

            ],
          ),
          FoodCard(
            text: 'Cheese',
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(productName: 'Cheese',price: '300',imageURL: 'assets/foodImages/cheese.jpg',)));
            },
            imageURL: 'assets/images/chees.gif',
          ),
          FoodCard(
            text: 'Fresh Milk',
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(productName: 'Fresh Milk',price: '180',imageURL: 'assets/foodImages/milk.jpg',)));
            },
            imageURL: 'assets/images/freshmilk.gif',
          ),
          FoodCard(
            text: 'Butter',
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(productName: 'Fresh Milk',price: '200',imageURL: 'assets/foodImages/butter.png',)));
            },
            imageURL: 'assets/images/butter.gif',
          ),

        ]),
      ),
    ));
  }
}

class FoodCard extends StatelessWidget {
  final String imageURL;
  final String text;
  final Function onPressed;
  const FoodCard({
    Key key, this.imageURL, this.text, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.all(15),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:Color(0xFF61A4F1),
            boxShadow: [
              BoxShadow(
                spreadRadius: 5,
                blurRadius: 5,
                color:  Color(0xFF478DE0),
              )
            ]
          ),
          child: Row(
            children: [
              Container(
                width: 150,height: 150,
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('$imageURL')
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: Container(height: 100,width: 3, color: Colors.red,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:38.0),
                child: Text(
                    '$text',
                  style: GoogleFonts.balsamiqSans(fontSize: 20,color: Colors.white),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
