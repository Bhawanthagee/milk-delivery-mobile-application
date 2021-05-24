import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noyan_app/authentications/login.dart';
import 'package:noyan_app/authentications/updateProfile.dart';
import 'package:noyan_app/screensForRider/riderHome.dart';



class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _fireStore = FirebaseFirestore.instance;
  String first_name,second_name,roll,address,branch,tel;
  final _auth = FirebaseAuth.instance;
  User user;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserDetails();

  }
  Future getUserDetails()async{
    user =  _auth.currentUser;

    DocumentSnapshot userDetails=await _fireStore.collection('users').doc(user.email).get();
    DocumentSnapshot userDetails2=await _fireStore.collection('users').doc(user.email).get();


    setState(() {
      first_name = userDetails['first_name'];
      second_name = userDetails['last_name'];
      roll = userDetails['roll'];
      address = userDetails['address'];

    });
    setState(() {
      tel = userDetails2['tele'];

    });
print('${user.email}\n firstName: $first_name\n Last Name: $second_name\n Role:$roll\n Adress: $address');
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          elevation: 20.0,

        ),
        body:Column(
          children: [
            Center(
              child:Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/biker_profile.png'),
                  backgroundColor: Colors.transparent,
                  radius: 60,
                ),
              ) ,
            ),
            SizedBox(height: 18,),
            Text("$first_name",style: TextStyle(fontSize: 30),),
            SizedBox(height: 18,),
            Text("$second_name",style: TextStyle(fontSize: 18,color: Colors.black45),),
            SizedBox(height: 48,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //ReUsableProfileCard(item: loggedInUSer.email),
                  SizedBox(height: 18,),
                  ReUsableProfileCard(item: "Address: $address"),
                  SizedBox(height: 18,),
                  ReUsableProfileCard(item: "Role: $roll"),SizedBox(height: 18,),
                  ReUsableProfileCard(item: "$tel"),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(top :8.0,right: 25,left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        RaisedButton(onPressed:(){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));


                        },
                          child: Text("Log Out",style: TextStyle(color: Colors.black),),)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )

    );
  }
}

class ReUsableProfileCard extends StatelessWidget {
  final String item;

  const ReUsableProfileCard({
    Key key, this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height:55,
      decoration: BoxDecoration(
          color: Color(0xFFe8e8e8),
          borderRadius: BorderRadius.circular(30),
          boxShadow:[
            BoxShadow(
                color: Colors.grey,
                blurRadius: 8.0,
                offset: Offset(0.0,8.0)
            )
          ]
      ),
      child: Center(child: Text(item,style: TextStyle(fontWeight: FontWeight.bold),)),
    );
  }
}
