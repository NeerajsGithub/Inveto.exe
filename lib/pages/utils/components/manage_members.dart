import 'package:flutter/material.dart';
import 'package:flutterupdated/global_func.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class ManageMembersPage extends StatefulWidget {
  @override
  State<ManageMembersPage> createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage> {
  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.fetchMembers(homeProvider.currentUser!['email']);
  }

  Future<void> _refresh() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    await provider.fetchMembers(provider.currentUser!['email']);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final members = homeProvider.members;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Members'),
      ),
      body: 
        Provider.of<HomeProvider>(context, listen: false).stores.isNotEmpty ?
        RefreshIndicator(
        backgroundColor: Colors.white,
        color: Color.fromRGBO(6, 148, 132, 1),
        onRefresh: _refresh,
        child: members.isEmpty
            ? Center(
                child: Text('No members available'),
              )
            : ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final image = member['image'];

                  return Card(
                    elevation: 4, // Add elevation with shadow
                    shadowColor: Colors.black.withOpacity(0.2), // Shadow color with opacity
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      side: BorderSide(color: Color.fromARGB(0, 208, 204, 204).withOpacity(0.5), width: 1), 
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        
                        leading: ClipOval(
                          child: image != null ? Image.network( 'https://clever-shape-81254.pktriot.net/uploads/$image' , width: 70,) : Icon(Icons.person, color: Color.fromRGBO(6, 148, 132, 1),size: 70,) // Display initials or placeholder
                        ),
                        title: Text(member['name']!= "" ? member['name'] : 'User' , style: TextStyle( fontWeight: FontWeight.w500 ,fontSize: 20 , color: const Color.fromARGB(255, 61, 61, 61) ),),
                        subtitle: Text(member['email'] ?? 'Email not available'),
                        trailing: homeProvider.currentUser?['id'] == homeProvider.members[0]['owner']
                            ? IconButton(
                                icon: Icon(Icons.delete ,),
                                onPressed: () {
                                  homeProvider.deleteMember(member['email'], context);
                                },
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
      )
      :
      Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageLoader(
                'https://cdn0.iconfinder.com/data/icons/flatt3d-icon-pack/512/Flatt3d-Box-1024.png',
                MediaQuery.of(context).size.width * 0.20,
              ),
              Text(
                'At least one store ',
                style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65), fontSize: 20),
              ),
              Text(
                'should be available to access',
                style: TextStyle(color: const Color.fromARGB(255, 65, 65, 65)),
              ),
              SizedBox(height: 70,)
            ],
          ),
      ),
    );
  }
}
