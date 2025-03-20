import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterupdated/global_func.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class ManageStoresPage extends StatefulWidget {
  
  @override
  State<ManageStoresPage> createState() => _ManageStoresPageState();
}

class _ManageStoresPageState extends State<ManageStoresPage> {

  void initState() {
    super.initState();
    // Fetch user details when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchStores();
    });
  }

  void _showCreateStoreDialog(BuildContext context) {
    TextEditingController _storeNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Create Store"),
          content: TextField(
            autofocus: true,
            controller: _storeNameController,
            decoration: InputDecoration(
              hintText: "Enter store name",
              hintStyle: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.03,
              decoration: BoxDecoration(
                color: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  String? userEmail = Provider.of<HomeProvider>(context, listen: false).currentUser != null ? Provider.of<HomeProvider>(context, listen: false).currentUser!['email'] : null;
                  String storeName = _storeNameController.text.trim();

                  if (userEmail != null && storeName.isNotEmpty) {
                    Provider.of<HomeProvider>(context, listen: false).createStore(userEmail, storeName , context);
                    Provider.of<HomeProvider>(context, listen: false).fetchStores();
                  } else {
                    print('User email is null or store name is empty $userEmail $storeName');
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Create",
                  style: TextStyle(color: Color.fromRGBO(68, 68, 68, 1), fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
  final provider = Provider.of<HomeProvider>(context, listen: false);
  await provider.fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final List<Map<String, dynamic>> stores = provider.stores;
    final currentUser = provider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Manage Stores',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(225, 51, 51, 51),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          currentUser != null && stores.isNotEmpty ?
          RefreshIndicator(
            backgroundColor: Colors.white,
            color: Color.fromRGBO(6, 148, 132, 1),
            onRefresh: _refresh ,
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
            
                final storeName = store['storeName'] ;
                final storeImageUrl = 'https://cdn0.iconfinder.com/data/icons/flatt3d-icon-pack/512/Flatt3d-Box-1024.png';
                final storeInventory = store['inventory']?.toString() ?? '0';
            
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(107, 231, 230, 230),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: ListTile(
                    leading: imageLoader(
                      storeImageUrl,
                      60,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${storeName}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 58, 58, 58),
                          ),
                        ),
                        Text(
                          ' Inventory: $storeInventory',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 87, 87, 87),
                          ),
                        ),
                        ElevatedButton( style: ButtonStyle( 
                          shadowColor: WidgetStateColor.transparent , 
                          padding: WidgetStateProperty.all(EdgeInsets.zero) , 
                          backgroundColor: WidgetStateProperty.all(Color.fromARGB(0, 231, 230, 230),),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, ),
                          onPressed: () { provider.downloadAndOpenExcelFile( context , provider.currentUser?['email'] , storeName); }, child: Row(
                          mainAxisSize: MainAxisSize.min, // Shrinks the row to its contents
                          children: [
                            Icon(Icons.download),
                            SizedBox(width: 2), // Adjust the width to control the space between icon and text
                            Text(
                              'Get Entries',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(6, 148, 132, 1),
                              ),
                            ),
                            ]))
                      ],
                    ),
                    trailing: provider.currentUser?['id'] == provider.stores[0]['owner']
                    ? IconButton(
                        icon: Icon(Icons.delete, color: const Color.fromARGB(255, 87, 87, 87)),
                        onPressed: () {
                          print(store['storeID']);
                          provider.deleteStore(store['storeID']);
                          _refresh();
                        },
                      )
                    : null,
                  ),
                );
              },
            ),
          )
          :RefreshIndicator(
            backgroundColor: Colors.white,
            color: Color.fromRGBO(6, 148, 132, 1),
            onRefresh: _refresh ,
            child: Center(
                        child: Text('No stores available'),
                      ),
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
                      height: MediaQuery.of(context).size.width * 0.052,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, size: 30, color: Colors.white),
                        onPressed: () {
                          _showCreateStoreDialog(context);
                        },
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
