import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutterupdated/pages/components/scanned_product.dart';
import 'package:flutterupdated/pages/homepage.dart';
import 'package:flutterupdated/provider/homeProvider.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'QR Code Scanner',
      home: MyHome(),
    ),
  );
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  Widget _buildItem(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner Example')),
      body: Center(
        child: ListView(
          children: [
            _buildItem(
              context,
              'Start QR Code Scanner',
              const QRViewExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? result;
  bool isNavigated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcode) {
          final List<Barcode> barcodes = barcode.barcodes; // Get the list of barcodes
          if (barcodes.isNotEmpty && !isNavigated) {
            setState(() {
              result = barcodes.first.rawValue; // Access rawValue from the first barcode
              print(result);
              isNavigated = true;// Prevent further navigation

              final provider = Provider.of<HomeProvider>(context, listen: false);
              final matchingProduct = provider.products.firstWhere(
                (product) => product['product_id'] == result,
                orElse: () => {},
              );

              if (matchingProduct.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ScannedProduct(p_id: result!),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => StorePage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                  ModalRoute.withName('/'),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Invalid unregistered QR!',
                      style: TextStyle(color: Colors.white), // Change text color
                    ),
                    backgroundColor:
                        Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }
}
