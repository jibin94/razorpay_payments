import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter_template/razorpay.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RazorPayIntegration _integration = RazorPayIntegration();
  @override
  void initState() {
    super.initState();
    _integration.initiateRazorPay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text("Razorpay Payments",style: TextStyle(fontSize: 16,color: Colors.white)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _integration.openSession(amount: 10);
          },
          child: const Text("Pay Amount"),
        ),
      ),
    );
  }
}
