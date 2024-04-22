import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScannedPage extends StatelessWidget {
  final String code;
  final Function() closeScreen;
  const ScannedPage({super.key, required this.closeScreen, required this.code});

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
      body: Column(
        children: [
          //show QR code
          QrImageView(
            data: 'code',
            size: 50,
            version: QrVersions.auto,
          ),
          Text(
            'Scanned Result',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            code,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                'Copy',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))
        ],
      ),
    );
  }
}
