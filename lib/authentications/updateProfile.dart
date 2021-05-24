import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noyan_app/dialog%20box/doneDialog.dart';
import 'package:noyan_app/screebs_forCustomer/homepage.dart';


class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _key = GlobalKey<FormState>();

  String imageURL;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String first_name,last_name,tele,position,branch,address;



  uploadData()async{
    await _fireStore.collection('users').doc(loggedInUSer.email).update({
      'email':loggedInUSer.email,
      'first_name':first_name,
      'last_name':last_name,
      'tele':tele,
      'address' :address

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Form(

                key:_key,
                child: SingleChildScrollView(
                  child: Column(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,left: 18,right: 18
                        ),
                        child: TextFormField(

                            onChanged: (value) {
                              first_name = value;
                            },
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return " field can not be emplty";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,left: 18,right: 18
                        ),
                        child: TextFormField(

                            onChanged: (value) {
                              last_name = value;
                            },
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return " field can not be emplty";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )),
                            )
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,left: 18,right: 18
                        ),
                        child: TextFormField(

                            onChanged: (value) {
                              tele = value;

                            },
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return " field can not be emplty";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Telephone",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,left: 18,right: 18
                        ),
                        child: TextFormField(
                            maxLines: 3,
                            onChanged: (value) {
                              address = value;

                            },
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return " field can not be emplty";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "address",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )),
                            )
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(left:58.0,right: 58,top: 28),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () async {
                              if (_key.currentState.validate()){
                                try{
                                  uploadData();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DoneDialogBox('Profile Updated');
                                      });
                                }catch (e){
                                  print(e);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DoneDialogBox(e.toString());
                                      });
                                }


                              }

                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xff5F67FF),
                                        Color(0xff7e85ff),
                                        Color(0xffbfc2ff),
                                      ])),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    maxWidth: double.infinity, minHeight: 50),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12,),

                    ],
                  ),
                ),

              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height*.3,
                    width: MediaQuery.of(context).size.width*.8,
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        image: DecorationImage(
                            image: AssetImage('assets/logos/milkPanda.png'),
                            fit: BoxFit.fitHeight

                        )
                    ),

                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }




}
