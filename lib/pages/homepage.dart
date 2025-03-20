import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterupdated/pages/components/scanned_product.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutterupdated/global_func.dart';
import 'package:flutterupdated/pages/other/qr_scanner.dart';
import 'package:flutterupdated/pages/racks.dart';
import 'package:flutterupdated/pages/utils/notifications.dart';
import 'package:flutterupdated/pages/utils/profile.dart';
import 'package:flutterupdated/pages/utils/searchbar.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchStores();
      provider.fetchProducts(context);
      provider.fetchRequests();
    });
  }
  
 Widget showStores(HomeProvider provider, BuildContext context) {
  if (provider.stores.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageLoader(
            'https://cdn0.iconfinder.com/data/icons/flatt3d-icon-pack/512/Flatt3d-Box-1024.png',
            MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            'No stores available!',
            style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65), fontSize: 20),
          ),
          Text(
            'Navigate to profile to manage stores',
            style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65)),
          ),
        ],
      ),
    );
  } else {
    // Limit the number of stores to 20 (5 rows x 4 columns)
    final limitedStores = provider.stores.take(20).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 4 columns
        // crossAxisSpacing: 16.0, // Horizontal spacing between items
        // mainAxisSpacing: 16.0, // Vertical spacing between items
        childAspectRatio: 1.1, // Adjust this ratio to control card height/width
      ),
      itemCount: limitedStores.length,
      shrinkWrap: true, // Prevents GridView from taking infinite height
      physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling (handled by CustomScrollView)
      itemBuilder: (context, index) {
        final store = limitedStores[index];
        return GestureDetector(
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => StorePreviewPage(store: store),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              // color: const Color.fromARGB(107, 231, 230, 230),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageLoader(
                  'https://cdn0.iconfinder.com/data/icons/flatt3d-icon-pack/512/Flatt3d-Box-1024.png',
                  120, // Reduced size to fit grid
                ),
                const SizedBox(height: 10),
                Text(
                  store['storeName'] ?? '',
                  style: const TextStyle(
                    fontSize: 22, // Adjusted font size for grid
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Inventory: ${store['inventory'] ?? '0'}',
                  style: const TextStyle(
                    fontSize: 12, // Adjusted font size
                    color: Color.fromARGB(255, 79, 79, 79),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Updated: ${store['lastUpdated'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 10, // Adjusted font size
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

  Future<void> _refresh() async {
  final provider = Provider.of<HomeProvider>(context, listen: false);
  await provider.fetchStores();
  }

  @override
  Widget build(BuildContext context) {
  final provider = Provider.of<HomeProvider>(context);

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

  void _showConnectStoreDialog(BuildContext context) {
    TextEditingController _storeCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Connect Store"),
          content: TextField(
            autofocus: true,
            controller: _storeCodeController,
            decoration: InputDecoration(hintText: "Enter store code", hintStyle: TextStyle(fontWeight: FontWeight.w400)),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)
              ),
              child: TextButton(
                onPressed: () {
                  if( _storeCodeController.text.isNotEmpty ) {
                    provider.requestStore(_storeCodeController.text , context);
                    Navigator.pop(context);
                  }
                },
                child: Text("Connect", style: TextStyle(color: Color.fromRGBO(73, 73, 73, 1), fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        );
      },
    );
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
              width: MediaQuery.of(context).size.width * 0.001,
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

   void _showOptionDialog(BuildContext context) {
    showDialog(
      barrierColor: Color.fromARGB(113, 49, 49, 49),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Choose an option"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text("Create Store"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showCreateStoreDialog(context);
                    },
                    tileColor: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.1), // Background color with some opacity
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                  ),
                  SizedBox(height: 10, width: 100),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text("Connect Store"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showConnectStoreDialog(context);
                    },
                    tileColor: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.1), // Background color with some opacity
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget checkStore() {
    if (provider.stores.isEmpty) {
      return IconButton(
        icon: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          _showOptionDialog(context);
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () async {

          TextEditingController _qrController = TextEditingController();

          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissing while scanning
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Scanning QR"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _qrController,
                      autofocus: true, // Auto-focus for direct input
                      decoration: InputDecoration(
                        hintText: "Scanning...",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ScannedProduct(p_id: _qrController.text),
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
                      }},
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(), // Loading animation
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

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
            SizedBox(width: 20),
            Image.asset(
              'lib/images/logo.png',
              height: 50,
              color: Color.fromRGBO(6, 148, 132, 1),
            ),
            SizedBox(width: 8),
            Text(
              'Inveto',
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 54, 54, 54),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
      icon: Icon(Icons.search, size: 28, color: Color.fromARGB(255, 54, 54, 54)),
      onPressed: () {
        print(provider.stores);
        Navigator.of(context).push(_createRoute());
      },
    ),
    IconButton(
      icon: Icon(Icons.refresh, size: 28, color: Color.fromARGB(255, 54, 54, 54)),
      onPressed: () {
        _refresh();
      },
    ),
    if (provider.currentUser?["requests"] == null)
      IconButton(
        icon: Icon(Icons.notifications_outlined, size: 28, color: Color.fromARGB(255, 54, 54, 54)),
        onPressed: () {
          print('Requests: ${provider.requests}');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
        },
      )
    else
      IconButton(
        icon: Icon(Icons.notifications_on_outlined, size: 28, color: Color.fromARGB(255, 54, 54, 54)),
        onPressed: () {
          print('Requests: ${provider.requests}');
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
        RefreshIndicator(
          backgroundColor: Colors.white,
          color: Color.fromRGBO(6, 148, 132, 1),
          onRefresh: _refresh,
          child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                if (provider.stores.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageLoader(
                          'https://cdn0.iconfinder.com/data/icons/flatt3d-icon-pack/512/Flatt3d-Box-1024.png',
                          MediaQuery.of(context).size.width * 0.1,
                        ),
                        Text(
                          'No stores available!',
                          style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65), fontSize: 20),
                        ),
                        Text(
                          'Navigate to profile to manage stores',
                          style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65)),
                        ),
                        SizedBox(height: 100,)
                      ],
                    ),
                  );
                } else {
                  return CustomScrollView(
                    slivers: [
                     SliverPadding(
                    padding: EdgeInsets.only( top: 8 ),
                    sliver: SliverToBoxAdapter(
                      child: showStores(provider, context),
                    ),
                  ),
                    ],
                  );
                }}
          ),
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
                    width : MediaQuery.of(context).size.width * 0.01,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 103, 92, 1).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        checkStore(),
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