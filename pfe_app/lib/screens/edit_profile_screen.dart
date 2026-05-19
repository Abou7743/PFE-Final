import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  TextEditingController nomController =
      TextEditingController();

  TextEditingController emailController =
      TextEditingController();

  TextEditingController telController =
      TextEditingController();

  // 🔥 AJOUT
  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    nomController.text =
        prefs.getString("nom") ?? "";

    emailController.text =
        prefs.getString("email") ?? "";

    telController.text =
        prefs.getString("telephone") ?? "";
  }

  // 🔥 AJOUT
  Future pickImage() async {

    final picked =
        await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      setState(() {

        imageFile =
            File(picked.path);

      });
    }
  }

  void save() async {

    final prefs =
        await SharedPreferences.getInstance();

    String? userId =
        prefs.getString("id");

    // 🔥 MULTIPART REQUEST
    var request =
        http.MultipartRequest(

      'POST',

      Uri.parse(
        "http://127.0.0.1:8000/api/update-profile/",
      ),
    );

    request.fields['id'] =
        userId ?? "";

    request.fields['nom'] =
        nomController.text;

    request.fields['email'] =
        emailController.text;

    request.fields['telephone'] =
        telController.text;

    // 🔥 IMAGE
    if (imageFile != null) {

      request.files.add(

        await http.MultipartFile.fromPath(
          'profile_image',
          imageFile!.path,
        ),
      );
    }

    var response =
        await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {

      await prefs.setString(
        "nom",
        nomController.text,
      );

      await prefs.setString(
        "email",
        emailController.text,
      );

      await prefs.setString(
        "telephone",
        telController.text,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Profil mis à jour ✅",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Erreur mise à jour ❌",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.all(20),

          child: Column(
            children: [

              // HEADER
              Row(
                children: [

                  IconButton(
                    icon: Icon(Icons.arrow_back),

                    onPressed: () =>
                        Navigator.pop(context),
                  ),

                  Text(
                    "Modifier Profil",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 🔥 PHOTO PROFIL
              GestureDetector(

                onTap: pickImage,

                child: CircleAvatar(

                  radius: 50,

                  backgroundImage:

                      imageFile != null
                      ? FileImage(imageFile!)
                      : null,

                  child: imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          size:40,
                        )
                      : null,
                ),
              ),

              SizedBox(height: 20),

              // CHAMPS
              customField(
                nomController,
                "Nom",
              ),

              SizedBox(height: 15),

              customField(
                emailController,
                "Email",
              ),

              SizedBox(height: 15),

              customField(
                telController,
                "Téléphone",
              ),

              SizedBox(height: 30),

              // BOUTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: save,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF3E6F55),

                    padding:
                        EdgeInsets.symmetric(
                      vertical: 15,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),

                  child: Text("Enregistrer"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customField(
      controller,
      hint) {

    return TextField(

      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
      ),
    );
  }
}