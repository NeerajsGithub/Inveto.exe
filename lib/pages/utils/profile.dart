import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterupdated/main.dart';
import 'package:flutterupdated/pages/utils/components/account.dart';
import 'package:flutterupdated/pages/utils/components/manageProducts.dart';
import 'package:flutterupdated/pages/utils/components/manage_members.dart';
import 'package:flutterupdated/pages/utils/components/manage_stores.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch user details when the page initializes
    Provider.of<HomeProvider>(context, listen: false).fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final currentUser = provider.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: currentUser != null
          ? _buildProfileContent(currentUser)
          : _buildLoadingIndicator(),
    );
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(
        text: Provider.of<HomeProvider>(context, listen: false)
            .stores[0]['storeID']));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  Widget _buildProfileContent(Map currentUser) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final bool isPortrait = height > width;

    String imagePath = currentUser['image'].toString().replaceAll("'", "").trim();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.05),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust layout for larger screens like Desktop
            if (constraints.maxWidth > 800) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image and Details
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox( height: 30 ),
                        Container(
                          child: ClipOval(
                            child: currentUser['image'] is String
                                ? Image.network(
                                    'https://clever-shape-81254.pktriot.net/uploads/$imagePath',
                                    width: width * 0.15,
                                    height: width * 0.15,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    color: Color.fromRGBO(6, 148, 132, 1),
                                    Icons.account_circle,
                                    size: width * 0.2,
                                  ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          currentUser['name'] != "" ? currentUser['name'] : 'User',
                          style: TextStyle(
                            color: Color.fromARGB(255, 84, 82, 82),
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          currentUser['email'] ?? 'user@gmail.com',
                          style: TextStyle(
                            color: Color.fromARGB(255, 59, 59, 59),
                            fontSize: width * 0.02,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox( height: 20 ),
                        Consumer<HomeProvider>(
                          builder: (context, provider, child) {
                            if (provider.stores.isNotEmpty &&
                                provider.stores[0].isNotEmpty) {
                              final id = provider.currentUser!['id'];
                              final owner = provider.stores[0]['owner'];
                              final storeID = provider.stores[0]['storeID'];

                              if (id == owner) {
                                return TextButton.icon(
                                  onPressed: () => copyToClipboard(),
                                  icon: Icon(
                                    Icons.copy,
                                    color: Color.fromARGB(255, 104, 104, 104),
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Connect StoreID',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 105, 105, 105),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(height: 10);
                              }
                            } else {
                              return SizedBox(height: 10);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Menu Options
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMenuButton(context, 'Account', Icons.account_box, AccountPage()),
                        SizedBox(height: 15),
                        _buildMenuButton(context, '  Stores', Icons.store, ManageStoresPage()),
                        SizedBox(height: 15),
                        _buildMenuButton(context, 'Products', Icons.toll_outlined, ManageProductsPage()),
                        SizedBox(height: 15),
                        _buildMenuButton(context, 'Members', Icons.person, ManageMembersPage()),
                        SizedBox(height: height * 0.025),
                        // Adding the SignOut button here
                        GestureDetector(
                          onTap: () {
                            Provider.of<HomeProvider>(context, listen: false).logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => IntroPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.008),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(6, 148, 132, 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextButton.icon(
                                label: Text(
                                  'SignOut',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                icon: Icon(Icons.exit_to_app_sharp, color: Colors.white),
                                iconAlignment: IconAlignment.end,
                                onPressed: () {
                                  Provider.of<HomeProvider>(context, listen: false).logout();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => IntroPage()),
                                    ModalRoute.withName('/'),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ClipOval(
                      child: currentUser['image'] is String
                          ? Image.network(
                              'https://clever-shape-81254.pktriot.net/uploads/$imagePath',
                              width: width * 0.3,
                              height: width * 0.3,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              color: Color.fromRGBO(6, 148, 132, 1),
                              Icons.account_circle,
                              size: width * 0.3,
                            ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    currentUser['name'] != "" ? currentUser['name'] : 'User',
                    style: TextStyle(
                      color: Color.fromARGB(255, 84, 82, 82),
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    currentUser['email'] ?? 'user@gmail.com',
                    style: TextStyle(
                      color: Color.fromARGB(255, 59, 59, 59),
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  _buildMenuButton(context, 'Account', Icons.account_box,
                      AccountPage()),
                  SizedBox(height: 15),
                  _buildMenuButton(context, 'Stores', Icons.store,
                      ManageStoresPage()),
                  SizedBox(height: 15),
                  _buildMenuButton(context, 'Products', Icons.toll_outlined,
                      ManageProductsPage()),
                  SizedBox(height: 15),
                  _buildMenuButton(context, 'Members', Icons.person,
                      ManageMembersPage()),
                  SizedBox(height: height * 0.025),
                  GestureDetector(
                    onTap: () {
                      Provider.of<HomeProvider>(context, listen: false)
                          .logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => IntroPage()),
                      );
                    },
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(6, 148, 132, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: TextButton.icon(
                          label: Text(
                            'SignOut',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          icon: Icon(Icons.exit_to_app_sharp,
                              color: Colors.white),
                          iconAlignment: IconAlignment.end,
                          onPressed: () {
                            Provider.of<HomeProvider>(context, listen: false)
                                .logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IntroPage()),
                              ModalRoute.withName('/'),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, Widget page) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(66, 213, 213, 213),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Color.fromRGBO(6, 148, 132, 1),
              size: width * 0.05,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: Color.fromARGB(255, 79, 79, 79),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
