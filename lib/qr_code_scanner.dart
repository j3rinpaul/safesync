// import 'package:safesync/sample.dart';

// void main() {
//   // Sample newsam = new Sample(10, 20);
//   // newsam.display();
//   Sample(a, b)
// }

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safe/scanned_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isScanCompleted = false;
  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SafeSync',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 156, 33, 212),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place  the QR code in this area',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              //    Container(
              //   color: Colors.grey,
              //   height: 250,
              //   width: 300,
              // ),
              MobileScanner(onDetect: (BarcodeCapture barcodeCapture) {
                if (isScanCompleted) {
                  String code = barcodeCapture.raw ?? '---';
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScannedPage(closeScreen: closeScreen,code: code,)));
                }
              }),
              SizedBox(
                height: 30,
              ),
              Text(
                'QR Scanner',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
        ));
  }
}
