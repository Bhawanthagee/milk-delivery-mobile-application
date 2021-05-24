import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noyan_app/screebs_forCustomer/homepage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  final String productName;
  final String price;
  final String imageURL;

  const Payment({Key key, this.productName, this.price, this.imageURL})
      : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String price;
  double totalPrice;
  TextEditingController _count = TextEditingController();
  Razorpay _razorpay;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DatabaseReference _realTimeDB = FirebaseDatabase.instance.reference();
  String _locationMessage = "";
  String lat,long;
  CollectionReference users = FirebaseFirestore.instance.collection('Orders');

  void _getCurrentLocation() async {

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      lat = '${position.latitude}';
      long = '${position.longitude}';

    });



  }

Future <void> onlinePayment()async{
  totalPrice = double.parse(_count.text)*double.parse(widget.price);

  try{
    await _fireStore.collection('Orders').doc().set({
      'email':loggedInUSer.email,
      'product' : widget.productName,
      'item_count' : _count.text,
      'item_price' : widget.price,
      'total_price' : totalPrice,
      'latitude' :lat,
      'longitude' : long,
      'paymentMethod' : 'cod',// cop = cash on delivery
      'name' : fullName,
      'status' :'pending',
      'tele':tele

    });
  }catch(e){
    print(e);
  }
}
 Future <void> cashOnDeliveryUpload(BuildContext context)async{


    totalPrice = double.parse(_count.text)*double.parse(widget.price);

    try{
      await _fireStore.collection('Orders').doc().set({
        'email':loggedInUSer.email,
        'product' : widget.productName,
        'item_count' : _count.text,
        'item_price' : widget.price,
        'total_price' : totalPrice,
        'latitude' :lat,
        'longitude' : long,
        'paymentMethod' : 'cod',// cop = cash on delivery
        'name' : fullName,
        'status' :'pending',
        'tele':tele

      });
    }catch(e){
      print(e);
    }
    Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 150,width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/donedone.png')
                      )
                    ),

                  ),
                )
              ],
            )
        )
    );
     print('email: ${loggedInUSer.email}\nproduct:${widget.productName}\nitemCount:${_count.text}\nitem price:${widget.price}\ntotal Price: ${totalPrice}\nlatitude: $lat\nlongitude: $long');

  }




  void calculatePrice(BuildContext context){
    totalPrice = double.parse(_count.text)*double.parse(widget.price);
    print(totalPrice);



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserName();
    _getCurrentLocation();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Place the Order',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: Builder(builder: (context){
            return Column(
              children: [
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('${widget.imageURL}'),
                              fit: BoxFit.contain)),
                    )),
                Text(
                  '${widget.productName}',
                  style: GoogleFonts.kalam(
                    fontSize: 45,
                  ),
                ),
                Text(
                  'Rs. ${widget.price}.00',
                  style: GoogleFonts.kalam(
                    fontSize: 35,
                  ),
                ),
                Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 150, right: 150),
                              child: TextField(

                                  controller: _count,
                                  decoration: InputDecoration(
                                      hintText: 'Enter Amount',hintStyle: TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: 5, color: Colors.blue)))),
                            ),
                            RaisedButton(
                                child: Text('Pay online'),
                                onPressed: () {
                                  onlinePayment();
                                  calculatePrice(context);
                                  openCheckout();
                                }),
                            RaisedButton(
                                child: Text('Cash on delivery'),
                                onPressed: () {
                                  calculatePrice(context);
                                  cashOnDeliveryUpload(context);

                                }),
                          ],
                        ),
                      ),
                    ))
              ],
            );
    },)
    ));
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_2icSMdiuQoYR9p', //key secret Za49XQ7wpVm2w9FgXJbZCjyE
      'amount':
          (totalPrice * 100.roundToDouble()).toString(),
      'name': '$fullName',
      'description': '${widget.productName}',
      'prefill': {'contact': '8888888888', 'email': '${loggedInUSer.email}'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("SUCCESS: " + response.paymentId)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "ERROR: " + response.code.toString() + " - " + response.message)));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName)));
  }
}

// SingleChildScrollView(
// child: Center(
// child: Column(
// children: [
// Text('${widget.productName}'),
// SizedBox(height: 150,),
// TextField(
// controller: _controller,
// decoration: InputDecoration(
// border : OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(
// width: 5,
// color: Colors.blue
// )
// )
// ),
//
// ),
// RaisedButton(
// child: Text('Pay'),
// onPressed: (){
// openCheckout();
// })
// ],
// )
// ),
// ),
