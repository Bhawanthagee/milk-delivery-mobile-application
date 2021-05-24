import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:noyan_app/dialog%20box/doneDialog.dart';
import 'package:noyan_app/screebs_forCustomer/homepage.dart';

class GoogleMaps extends StatefulWidget {
  final String lat,lng,documentID,tele,name;
  final int index;

  const GoogleMaps({Key key, this.lat, this.lng, this.index, this.documentID, this.tele, this.name}) : super(key: key);
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  //String latitude = (widget.lat);



  Set<Marker> _marker ={};
  final _fStore = FirebaseFirestore.instance;

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      _marker.add(
        Marker(
          infoWindow: InfoWindow(
            title: '${widget.tele}',
            snippet: '${widget.name}',

          ),
          markerId: MarkerId('id-1'),
          position: LatLng(double.parse(widget.lat), double.parse(widget.lng))
        )
      );
    });
  }
//6.083684, 80.645120

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(//order confirm button
              icon: Icon(Icons.done),
              iconSize: 30,
              color: Colors.lightGreenAccent,
              onPressed: ()async{
                await _fStore.collection('Orders').doc(widget.documentID).update({
                  'status' : "onDelivery"
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DoneDialogBox('Order Added Successfully');
                    });
              },
            ),
            IconButton(//delivery confirm button
              icon: Icon(Icons.cancel),
              iconSize: 30,
              color: Colors.redAccent,
              onPressed: ()async{
                await  _fStore.collection('Orders').doc(widget.documentID).update({
                  'status' : "pending"
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DoneDialogBox('Delivery Cancelled Successfully');
                    });
              },
            ),
            IconButton(//delivery confirm button
              icon: Icon(Icons.done_all_outlined),
              iconSize: 30,
              color: Colors.redAccent,
              onPressed: ()async{
                await _fStore.collection('Orders').doc(widget.documentID).delete();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DoneDialogBox('Order Delivered Successfully');
                    });

              },
            ),

          ],
          title:  Text('User Location'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _marker,
          initialCameraPosition:CameraPosition(
              target: LatLng( 7.299394, 80.644408), zoom: 7.5
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,




        )
      ),
    );
  }
}


