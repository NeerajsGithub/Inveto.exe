import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterupdated/pages/utils/notifications.dart';
import 'package:flutterupdated/pages/utils/searchbar.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductPage extends StatefulWidget {
  final String p_id;
  final String? rackId;
  final dynamic store;
  final quantity; // Change the type to match your store data type

  ProductPage({Key? key, required this.p_id, this.store, this.rackId, this.quantity}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    String enteredQuantity;
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final productList = provider.products;
    final currentProduct = productList.firstWhere(
      (product) => product['product_id'] == widget.p_id,
    );
    final image = currentProduct['image_url'];

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

    void getQuantity(BuildContext context) {
      TextEditingController quantityController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Dispatch"),
            content: TextField(
              autofocus: true,
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter dispatch quantity",
                hintStyle: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            actions: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      int? enteredQuantityValue = int.tryParse(quantityController.text);
                      int? maxQuantity = int.tryParse(widget.quantity);
                      if (enteredQuantityValue == null || enteredQuantityValue > maxQuantity!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Entered quantity is invalid")),
                        );
                      } else {
                        enteredQuantity = quantityController.text;
                        provider.deleteRack(widget.rackId!, widget.p_id, widget.store['storeID'], enteredQuantity);
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Color.fromRGBO(68, 68, 68, 1), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(100.0),
                    child: CachedNetworkImage(
                      imageUrl: 'https://clever-shape-81254.pktriot.net/uploads/products/$image',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      SizedBox( height: 80 ),
                      Text(
                        currentProduct['category'] ?? 'Lorem Ipsum',
                        style: TextStyle(
                          fontSize: 64, // Increased font size
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(12, 129, 115, 1),
                        ),
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      Padding(
                        padding: const EdgeInsets.only( right: 200 ),
                        child: Text(
                          currentProduct['product_name'] ??
                              'Lorem ipsum dolor',
                            
                          style: TextStyle(
                            fontSize: 18, // Increased font size
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 87, 87, 87),
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // Increased spacing
                      Padding(
                        padding: const EdgeInsets.only( right: 200 ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(49, 173, 113, 0.133),
                                ),
                                padding: EdgeInsets.all(20), // Increased padding
                                child: Column(
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(
                                        fontSize: 20, // Increased font size
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 72, 72, 72),
                                      ),
                                    ),
                                    Text(
                                      widget.quantity ?? "00",
                                      style: TextStyle(
                                        fontSize: 48, // Increased font size
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(6, 148, 132, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20), // Increased spacing
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(49, 173, 113, 0.133),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increased padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Code',
                                      style: TextStyle(
                                        fontSize: 20, // Increased font size
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 72, 72, 72),
                                      ),
                                    ),
                                    Text(
                                      currentProduct['product_id'] ?? '00',
                                      style: TextStyle(
                                        fontSize: 48, // Increased font size
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(6, 148, 132, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), 
                      Image.network(
                          'https://tse1.mm.bing.net/th?id=OIP._f5N423m8QWqzD-cO9n2UwAAAA&pid=Api&rs=1&c=1&qlt=95&w=375&h=124'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.02,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.47),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.061,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (widget.quantity == null)
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          else
                            TextButton(
                              onPressed: () => getQuantity(context),
                              child: Icon(Icons.bike_scooter, color: Colors.white , size: 30,),
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
