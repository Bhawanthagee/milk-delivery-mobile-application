import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class Activation extends StatefulWidget {
  @override
  _ActivationState createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {

  String nameOfTheUser;
  User u;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;


  getName()async{
    User user = _auth.currentUser;
    DocumentSnapshot name = await _fireStore.collection('users').doc(user.email).get();

    setState(() {
      nameOfTheUser = name['first_name'];
      u=user;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
           
            body: Column(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(top:28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logos/milkPanda.png')
                        )
                    ),
                  ),
                )),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:11.0),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: "Hello ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                TextSpan(text: "$nameOfTheUser!",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 23),),

                              ])),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 20.0,right: 20.0),
                      child:RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: "Welcome to our Milk Panda mobile application ",),
                                TextSpan(text: "$nameOfTheUser",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,),),
                                TextSpan(text: "  ,this is the first time you are using our mobile application.\nfirst of all we need to activate your account. \nYour account is not yet activated ",),

                              ])),
                    ),

                  ],
                ))
              ],
            )
        ),
      ),
    );
  }
}
