import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class PaymentPage extends StatefulWidget {
  final String title;
  final int price;

  const PaymentPage({
    required this.title,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? qrCodeData;
  String upiId = ""; // UPI ID will be fetched
  String payeeName = ""; // Payee name will be fetched

  @override
  void initState() {
    super.initState();
    fetchUpiDetails();
  }

  Future<void> fetchUpiDetails() async {
    try {
      // Fetch the UPI details from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('upiDetails') // Replace with your collection name
          .doc('CSMsoftUPI') // Replace with your document ID
          .get();

      setState(() {
        upiId = snapshot['upiId'];
        payeeName = snapshot['payeeName'];
      });
    } catch (e) {
      print("Error fetching UPI details: $e");
    }
  }

  void generateQRCode() {
    setState(() {
      qrCodeData =
          "upi://pay?pa=$upiId&pn=$payeeName&mc=&tid=${DateTime.now().millisecondsSinceEpoch}&am=${widget.price.toDouble()}&cu=INR&tn=Payment for ${widget.title}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D2A6D), Color(0xFF4B6CB7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Course Title
              Text(
                'Course: ${widget.title}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Price
              Text(
                'Price: ₹${widget.price}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 40),
              // Payment Method Card
              Card(
                color: Colors.white.withOpacity(0.1),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Payment Method:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'UPI: ${upiId.isNotEmpty ? upiId : 'Loading...'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Payee: ${payeeName.isNotEmpty ? payeeName : 'Loading...'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Pay Now Button
              Center(
                child: ElevatedButton(
                  onPressed: upiId.isNotEmpty ? generateQRCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Divider(thickness: 3),
              const SizedBox(height: 30),
              // QR Code Section
              if (qrCodeData != null) ...[
                const Center(
                  child: Text(
                    "Scan the QR Code to Pay:",
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: UPIPaymentQRCode(
                    upiDetails: UPIDetails(
                      upiID: upiId,
                      payeeName: payeeName,
                      amount: widget.price.toDouble(),
                      transactionNote: "Payment for ${widget.title}",
                    ),
                    size: 220,
                    embeddedImagePath: 'assets/Preview.png',
                    embeddedImageSize: const Size(60, 60),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Scan QR to Pay",
                    style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
                  ),
                ),
              ],
              const SizedBox(height: 30),

              // UPI Payment Disclaimer Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'UPI Payment Disclaimer:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._disclaimerPoints().map((point) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(point,
                                      style: const TextStyle(
                                          color: Colors.white70))),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _disclaimerPoints() {
    return [
      "Ensure a secure internet connection.",
      "Verify recipient's details before payment.",
      "Review app permissions carefully.",
      "Be aware of transaction limits.",
      "Check for any applicable fees.",
      "Wait for payment confirmation.",
      "Know the dispute resolution process.",
      "Regularly update your UPI app.",
      "Be cautious about sharing your UPI ID.",
      "Stay vigilant against fraud."
    ];
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(title: 'Sample Course', price: 500),
  ));
}
