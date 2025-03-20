import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterupdated/pages/components/select_store.dart';
import 'package:flutterupdated/pages/utils/searchbar.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScannedProduct extends StatefulWidget {
  final String p_id;

  const ScannedProduct({Key? key, required this.p_id}) : super(key: key);

  @override
  _ScannedProductState createState() => _ScannedProductState();
}

class _ScannedProductState extends State<ScannedProduct> {
  String? enteredQuantity;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final productList = provider.products;
    final currentProduct = productList.firstWhere(
      (product) => product['product_id'] == widget.p_id,
    );
    final image = currentProduct['image_url'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 54, 54, 54)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Color.fromARGB(255, 54, 54, 54)),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final horizontalPadding = isDesktop ? constraints.maxWidth * 0.1 : 20.0;
          final imageSize = isDesktop ? constraints.maxWidth * 0.3 : constraints.maxWidth * 0.8;

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: 'https://clever-shape-81254.pktriot.net/uploads/products/$image',
                                width: imageSize,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 3,
                            child: productDetails(context, constraints),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: 'https://clever-shape-81254.pktriot.net/uploads/products/$image',
                              width: imageSize,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 20),
                          productDetails(context, constraints),
                        ],
                      ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.width * 0.02,
                left: 0,
                right: 0,
                child: proceedButton(context, constraints),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget productDetails(BuildContext context, BoxConstraints constraints) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final productList = provider.products;
    final currentProduct = productList.firstWhere(
      (product) => product['product_id'] == widget.p_id,
    );
    final isDesktop = constraints.maxWidth > 800;
    final fontSizeMultiplier = isDesktop ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentProduct['category'] ?? 'Lorem Ipsum',
          style: TextStyle(
            fontSize: 20 * fontSizeMultiplier,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(12, 129, 115, 1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentProduct['product_name'] ?? 'Product Name',
          style: TextStyle(
            fontSize: 24 * fontSizeMultiplier,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isDesktop ? 30 : 25),
        Row(
          children: [
            Expanded(child: quantityBox(context, constraints)),
            SizedBox(width: isDesktop ? 30 : 20),
            Expanded(child: codeBox(currentProduct['product_id']!, constraints)),
          ],
        ),
        SizedBox(height: isDesktop ? 80 : 60), // Extra space for positioned button
      ],
    );
  }

  Widget quantityBox(BuildContext context, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 800;
    final padding = isDesktop ? 20.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Quantity',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton.icon(
            onPressed: () => getQuantity(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(6, 148, 132, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            label: Text(
              enteredQuantity ?? "Get data",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.add_box, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget codeBox(String code, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 800;
    final padding = isDesktop ? 20.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Code',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            code,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(6, 148, 132, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget proceedButton(BuildContext context, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 800;
    final buttonWidth = MediaQuery.of(context).size.width * 0.1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(constraints.maxWidth * 0.05),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: buttonWidth,
            height: constraints.maxWidth * 0.05,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.05),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (enteredQuantity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter the quantity to proceed')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectStore(pid: widget.p_id, pquantity: enteredQuantity),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                "Proceed",
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getQuantity(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Enter Quantity"),
          content: TextField(
            autofocus: true,
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter quantity",
              hintStyle: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  enteredQuantity = quantityController.text;
                  Navigator.of(context).pop();
                });
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Color.fromRGBO(6, 148, 132, 1)),
              ),
            ),
          ],
        );
      },
    );
  }
}