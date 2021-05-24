import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noyan_app/authentications/riderUserProfile.dart';
import 'package:noyan_app/screensForRider/map.dart';



class RiderHome extends StatefulWidget {
  @override
  _RiderHomeState createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {




 CollectionReference ref = FirebaseFirestore.instance.collection('Orders');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Interface'),
        actions: [
          IconButton(icon: Icon(Icons.account_circle_rounded),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
          },
          )
        ],

      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot>snapshot){
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
                itemBuilder: (context , index){
                final doc = snapshot.data.docs[index];
                final id = snapshot.data.docs[index].id;
                return ListTile(
                  leading: IconButton(

                    icon: Icon(Icons.location_on),
                    iconSize: 35,
                    color: Colors.red,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMaps(lat: '${doc['latitude']}',lng: '${doc['longitude']}',index: index,documentID: id,tele: '${doc['tele']}',name: '${doc['name']}',)));
                      print('Lat: ${doc['latitude']} Long: ${doc['longitude']} \nID: $id \n${doc['tele']}');
                    },
                  ),

                  title: Container(
                    height: 150,width: double.infinity,
                    decoration: BoxDecoration(

                      color: Colors.blue
                    ),
                    child:Container(
                      margin: EdgeInsets.all(10),
                      child:  Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Item: ${doc['product']}'),
                              Text('Count: ${doc['item_count']}'),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Name: ${doc['name']}'),
                              Text('Total: ${doc['total_price']}'),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Text('Order Status : ',style: TextStyle(color: Colors.purple),),
                              updatedStatus('${doc['status']}'),
                            ],
                          )
                        ],
                      ),
                    )
                  )
                );
                }
            );
          }
            return Text('Error');

        },
      )
    );
  }
}

Widget updatedStatus(String s) {
  if(s=='pending'){
   return Text('Pending....',style: TextStyle(color: Colors.lightGreenAccent),);
  }else{
    return Text('On Delivery....',style: TextStyle(color: Colors.redAccent),);
  }
}


// StreamBuilder<QuerySnapshot>(
// stream: Firestore.instance.collection("products").snapshots(),
// builder: (context, snapshot) {},
// );
// builder: (context, snapshot) {
// return !snapshot.hasData
// ? Text('PLease Wait')
//     : ListView.builder(
// itemCount: snapshot.data.documents.length,
// itemBuilder: (context, index) {
// DocumentSnapshot products =
// snapshot.data.documents[index];
// return ProductItem(
// name: products['name'],
// imageUrl: products['imageURL'],
// price: products['price'],
// discription: products['description'],
// );
// },
// );
// },