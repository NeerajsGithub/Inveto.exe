import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterupdated/pages/homepage.dart';
import 'package:flutterupdated/pages/product.dart';
import 'package:flutterupdated/pages/utils/searchbar.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class SelectRackPage extends StatefulWidget {
  const SelectRackPage({Key? key, required this.store , required this.pid , this.quantity }) : super(key: key);

  final Map<String, dynamic> store;
  final pid;
  final quantity;

  @override
  _SelectRackPageState createState() => _SelectRackPageState();
}

class _SelectRackPageState extends State<SelectRackPage> {
  String? selectedRack;

  void selectRack(String rack) {
    setState(() {
      selectedRack = rack;
      print(selectedRack);
    });
  }

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
                Expanded(child: rackManage('A', context,  widget.store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('B', context,  widget.store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('C', context,  widget.store)),
              ],
            ),
            SizedBox(height: 50), // Reduced space between rows
            // Bottom row with racks D, E, F
            Row(
              children: [
                Expanded(child: rackManage('D', context,  widget.store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('E', context,  widget.store)),
                SizedBox(width: 10), // Reduced space between columns
                Expanded(child: rackManage('F', context, widget.store)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void invalidMessenger(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ),
  );
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
        bool isSelected = selectedRack == label;
        bool isOccupied = store['data'][rackKey] != null &&
            store['data'][rackKey].any((rack) => rack['rack'] == label && rack['status'] == 'occupied');

        rowWidgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005), // Reduced padding
            child: SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  if (isOccupied) {
                    var rack = store['data'][rackKey]?.firstWhere(
                      (rack) => rack['rack'] == label && rack['status'] == 'occupied',
                    );
                    print(rack);

                    if(rack['status'] == 'occupied') invalidMessenger(context, "Rack is currently occupied.");
                  } else {
                    selectRack(label);
                  }
                },
                        
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isOccupied ? Color.fromRGBO(6, 119, 106, 1).withOpacity(0.7) : Color.fromRGBO(215, 219, 219, 0.719).withOpacity(0.7),
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      width: isSelected ? 1.5 : 0,
                      color: Color.fromARGB(163, 102, 102, 102),
                    ),
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

    final provider = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Image.asset(
                'lib/images/logo.png',
                height: 40,
                color: Color.fromRGBO(6, 148, 132, 1),
              ),
              SizedBox(width: 8),
              Text(
                'Inveto',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 54, 54, 54),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
            bottom: MediaQuery.of(context).size.width * 0.02,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.475),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.05,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.confirmation_num_outlined, color: Colors.white),
                            onPressed: () {
                              print(widget.pid);
                              provider.addToRack(selectedRack.toString(), widget.pid, widget.store['storeID'] ,widget.quantity );
                               Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => StorePage()),
                                ModalRoute.withName('/'), 
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
