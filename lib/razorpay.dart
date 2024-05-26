import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../api_services.dart';

class RazorPayIntegration {
  final Razorpay _razorpay = Razorpay(); //Instance of razor pay
  final razorPayKey = dotenv.get("RAZOR_KEY");
  final razorPaySecret = dotenv.get("RAZOR_SECRET");
  initiateRazorPay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showToast("Payment Successful, Payment ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    showToast("Payment Failed, Code: ${response.code}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToast("External Wallet Selected, Wallet name: ${response.walletName}");
  }

  openSession({required num amount}) {
    createOrder(amount: amount).then((orderId) {
      debugPrint(orderId);
      if (orderId.toString().isNotEmpty) {
        var options = {
          'key': razorPayKey, //Razor pay API Key
          'amount': amount, //in the smallest currency sub-unit.
          'name': 'Flutter Dev',
          'order_id': orderId, // Generate order_id using Orders API
          'description':
              'Description for order', //Order Description to be shown in razor pay page
          'timeout': 60, // in seconds
          'prefill': {
            'contact': '9544935236',
            'email': 'apptester2255@gmail.com'
          } //contact number and email id of user
        };
        _razorpay.open(options);
      } else {}
    });
  }

  createOrder({required num amount}) async {
    final myData = await ApiServices().razorPayApi(amount, "rcp_id_1");
    if (myData["status"] == "success") {
      debugPrint(myData.toString());
      return myData["body"]["id"];
    } else {
      return "";
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
