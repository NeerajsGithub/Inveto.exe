import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterupdated/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final currentUser = provider.currentUser;

    nameController.text = currentUser != null ? currentUser['name'] ?? '' : '';
    emailController.text = currentUser != null ? currentUser['email'] ?? '' : '';
    genderController.text = currentUser != null ? currentUser['gender'] ?? '' : '';

    if (currentUser != null && currentUser['image'] != null) {
      _imageFile = File(currentUser['image']);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_imageFile != null) {
        await Provider.of<HomeProvider>(context, listen: false).updateUserDetails(
          context,
          nameController.text,
          genderController.text,
          _imageFile!,
        );
        _imageFile = null;
      } else {
        print('Please select an image.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the screen is mobile or desktop
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Account Page',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(187, 53, 53, 53),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 500.0 : 20.0, // Wider padding for desktop
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile == null ?
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.8),
                    child: Icon(Icons.camera_alt, color: Colors.white),
                    radius: 100,
                  )
                  :
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(6, 148, 132, 1).withOpacity(0.8),
                    backgroundImage: FileImage(_imageFile!) ,
                    child: _imageFile == null ? Icon(Icons.camera_alt, color: Colors.white) : null,
                    radius: 100,
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 92, 92, 92),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 167, 167, 167)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(6, 148, 132, 1)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(fontSize: 15),
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 92, 92, 92),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 167, 167, 167)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(6, 148, 132, 1)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: genderController,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 92, 92, 92),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 167, 167, 167)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(6, 148, 132, 1)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(6, 148, 132, 1),
                            padding: EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {
                            _submitForm(context);
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
