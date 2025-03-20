import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutterupdated/pages/other/qr_scanner.dart';
import 'package:flutterupdated/pages/product.dart';
import 'package:flutterupdated/pages/utils/notifications.dart';
import 'package:flutterupdated/pages/utils/profile.dart';
import 'package:flutterupdated/pages/utils/searchbar.dart';

class StorePreviewPage extends StatelessWidget {
  const StorePreviewPage({Key? key, required this.store}) : super(key: key);

  final Map<String, dynamic> store;

  Widget storePreview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with racks A, B, C
            Row(
              children: [
                Expanded(child: rackManage('A', context, store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('B', context, store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('C', context, store)),
              ],
            ),
            SizedBox(height: 50), // Reduced space between rows
            // Bottom row with racks D, E, F
            Row(
              children: [
                Expanded(child: rackManage('D', context, store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('E', context, store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('F', context, store)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Perform some action
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget rackManage(String rackKey, BuildContext context, Map<String, dynamic> store) {
    List<Widget> columnButtons = [];

    // Calculate button width and height based on screen width
    final buttonWidth = MediaQuery.of(context).size.width * 0.066; // Reduced button width
    final buttonHeight = buttonWidth * (3.1 / 3); // Reduced button height

    for (int i = 1; i <= 6; i++) {
      List<Widget> rowWidgets = [];
      for (int j = 1; j <= 4; j++) {
        String label = '$rackKey$i$j';
        bool isOccupied = store['data'][rackKey] != null &&
            store['data'][rackKey].any((rack) => rack['rack'] == label && rack['status'] == 'occupied');

        rowWidgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005), // Reduced padding
            child: SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: isOccupied
                    ? () {
                        var rack = store['data'][rackKey]?.firstWhere(
                          (rack) => rack['rack'] == label && rack['status'] == 'occupied',
                        );
                        print(rack);
                        String productId = rack['product_id'];
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => ProductPage(
                              p_id: productId,
                              store: store,
                              rackId: label,
                              quantity: rack['quantity'],
                            ),
                          ),
                        );
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isOccupied ? Color.fromRGBO(6, 119, 106, 1).withOpacity(0.7) : Color.fromRGBO(215, 219, 219, 0.719).withOpacity(0.7),
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Reduced border radius
                    ),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isOccupied ? Color.fromARGB(255, 237, 237, 237) : Color.fromARGB(255, 130, 130, 130),
                    fontSize: MediaQuery.of(context).size.width * 0.012, // Reduced font size
                  ),
                ),
              ),
            ),
          ),
        );
      }
      columnButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3), // Reduced vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowWidgets,
          ),
        ),
      );
    }

    return Column(
      children: [
        TextButton.icon(
          onPressed: () => {},
          icon: Icon(Icons.filter_list, color: Color.fromARGB(255, 78, 78, 78), size: 18), // Reduced icon size
          label: Text(
            'Rack ${rackKey.toUpperCase()} (${store['storeName']})',
            style: TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 102, 102, 102), fontSize: 14), // Reduced font size
          ),
        ),
        Column(
          children: columnButtons,
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchBarPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
  automaticallyImplyLeading: false, // Prevents default back button
  surfaceTintColor: Colors.white,
  backgroundColor: Colors.white,
  leading: Navigator.canPop(context) // Check if back navigation is possible
      ? IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 54, 54, 54)),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      : null, // No back button if there's no previous page

  title: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        Image.asset(
          'lib/images/logo.png',
          height: 30,
          color: Color.fromRGBO(6, 148, 132, 1),
        ),
        SizedBox(width: 8),
        Text(
          'Inveto',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 54, 54, 54),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.search, size: 24, color: Color.fromARGB(255, 54, 54, 54)),
      onPressed: () {
        Navigator.of(context).push(_createRoute());
      },
    ),
    IconButton(
      icon: Icon(Icons.notifications_outlined, size: 24, color: Color.fromARGB(255, 54, 54, 54)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsPage()),
        );
      },
    ),
    SizedBox(width: 16),
  ],
),

      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: storePreview(context),
              ),
            ],
          ),
          Positioned(
  bottom: MediaQuery.of(context).size.width * 0.016,
  left: 0,
  right: 0,
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.45),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.01,
            decoration: BoxDecoration(
              color: Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                  onPressed: () async {
                    try {
                      final status = await Permission.camera.request();
                      if (status.isGranted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRViewExample()),
                        );
                      } else {
                        print('Camera permission denied.');
                      }
                    } catch (e) {
                      print('Error requesting camera permission: $e');
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}
