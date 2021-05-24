import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noyan_app/authentications/riderUserProfile.dart';
import 'package:noyan_app/screebs_forCustomer/beverages.dart';
import 'package:noyan_app/screebs_forCustomer/customerProfile.dart';
import 'package:noyan_app/screebs_forCustomer/dairy.dart';
import 'package:noyan_app/screebs_forCustomer/desserts.dart';
import 'package:noyan_app/screebs_forCustomer/short_eats.dart';
User loggedInUSer;
String addressOfTheUSer;
String fullName;
String tele;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  final _auth = FirebaseAuth.instance;
  Address _address;

  final _firebase = FirebaseFirestore.instance;
  StreamSubscription<Position> _streamSubscription;

  Future<void> getUSerName()async{
    DocumentSnapshot value =await _firebase.collection('users').doc(loggedInUSer.email).get();
    String firstName = value['first_name'].toString();
    String lastName = value['last_name'].toString();
    tele = value['tele'];
    fullName = '$firstName $lastName';
    print('$fullName');

  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUSer = user;
        print(loggedInUSer.email);
        print(loggedInUSer.uid);
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUSerName();
    _streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          if (mounted)
            setState(() {
              final coordinates =
              Coordinates(position.latitude, position.longitude);
              convertCoordinatesToAddress(coordinates)
                  .then((value) => _address = value);
            });
        });
    addressOfTheUSer ='${_address?.addressLine ?? '-'}';
  }
  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: [
            IconButton(icon: Icon(Icons.account_circle_rounded),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfile()));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:28.0, left: 10, right: 10,bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 150,
                        decoration: BoxDecoration(

                            image: DecorationImage(

                                image: AssetImage( 'assets/logos/milkPanda.png',)
                            )
                        ),
                      ),
                      Center(
                        child: Text(
                          'MILK PANDA',
                          style: GoogleFonts.chelaOne(color: Colors.white, fontSize: 40),
                        ),
                      ),

                    ],
                  ),

                ),
                Container(height: 2,width: double.infinity,color: Colors.yellowAccent,
                margin: EdgeInsets.only(left: 25,right: 25),),
                
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ReUsableCardLong(
                    text: 'Dairy Products',
                    imageURL: 'assets/images/cow.png',
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DairyProducts()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: CustomCardH(
                        text: 'Beverages',
                        imageURL: 'assets/images/beverages.png',
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Beverages()));
                        },
                      ),
                    ),
                    SizedBox(width: 25,),
                    Padding(
                      padding: const EdgeInsets.only(right:22.0),
                      child: CustomCardH(
                        text: 'Desserts',
                        imageURL: 'assets/images/desserts.png',
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Desserts()));
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ReUsableCardLong(
                    text: 'Short Eats',
                    imageURL: 'assets/images/sEats.png',
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShortEats()));
                    },
                  ),
                ),
              ],
            ),

          ),
        )
      ),
    );
  }
}

class ReUsableCardLong extends StatelessWidget {
  final String imageURL;
  final String text;
  final Function onPressed;
  const ReUsableCardLong({
    Key key, this.imageURL, this.text, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFF61A4F1),
          boxShadow: [
            BoxShadow(
              color:  Color(0xFF398AE5),
              spreadRadius: 3,
              blurRadius: 15,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]
        ),
        child: Row(
          children: [
            Expanded(
              flex:2,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('$imageURL')
                  )
                ),
              ),
            ),
            Expanded(
              flex:3,
            child: Container(
              margin: EdgeInsets.all(5),
                child: Text(
                    '$text',
                  style: GoogleFonts.balsamiqSans(color: Colors.white,fontSize: 25),
                ))
            ),

          ],
        ),
      ),
    );
  }
}

class CustomCardH extends StatelessWidget {
  final String text;
  final String imageURL;
  final Function onPressed;
  const CustomCardH({
    Key key, this.text, this.imageURL, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 250,
        width: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color:  Color(0xFF2e77c9),
              spreadRadius: 3,
              blurRadius: 15,
              offset: Offset(0, 3), //
            )
          ],
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFF61A4F1),
        ),
        child: Column(
          children: [
            Expanded(child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('$imageURL')
                )
              ),
            ),
            ),
            Container(
              height: 2,width: 80,color: Colors.red,
            ),
            Expanded(
                child: Container(
                  child: Center(child: Text('$text',style: GoogleFonts.balsamiqSans(fontSize: 25,color: Colors.white),)),
                )
            )
          ],
        ),
      ),
    );
  }
}
