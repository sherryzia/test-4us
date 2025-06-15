import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanTicketScreen extends StatefulWidget {
  const ScanTicketScreen({Key? key}) : super(key: key);

  @override
  State<ScanTicketScreen> createState() => _ScanTicketScreenState();
}

class _ScanTicketScreenState extends State<ScanTicketScreen> {
  String? _scanResult = "No result yet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Scan Ticket",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _scanResult ?? "No result",
              style: const TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? res = await SimpleBarcodeScanner.scanBarcode(
                  context,
                  barcodeAppBar: const BarcodeAppBar(
                    appBarTitle: 'Scan Ticket',
                    centerTitle: true,
                    enableBackButton: true,
                    backButtonIcon: Icon(Icons.arrow_back),
                  ),
                  isShowFlashIcon: true, // Show flash icon
                  delayMillis: 2000,     // Scanning delay
                  cameraFace: CameraFace.back, // Use back camera
                );

                // Update the scanned result
                setState(() {
                  _scanResult = res;
                });
              },
              child: const Text('Open Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
