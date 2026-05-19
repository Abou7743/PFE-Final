import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart'
    as http;

class RegisterScreen
    extends StatefulWidget {

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController
      nomController =
      TextEditingController();

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      telephoneController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  String role = "user";

  bool isLoading = false;

  bool hidePassword = true;

  // 🔥 REGISTER

  void register() async {

    setState(() {
      isLoading = true;
    });

    final prefs =
        await SharedPreferences.getInstance();

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
      telephoneController.text,
    );

    await prefs.setString(
      "password",
      passwordController.text,
    );

    final response =
        await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/register/",
      ),

      body: {

        'nom':
            nomController.text,

        'email':
            emailController.text,

        'telephone':
            telephoneController.text,

        'password':
            passwordController.text,
      },
    );

    print(
      "STATUS: ${response.statusCode}",
    );

    print(
      "BODY: ${response.body}",
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.green,

          content: Text(
            "Compte créé avec succès ✅",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.red,

          content: Text(
            "Erreur serveur ❌",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [

              Color(0xFF3E6F55),

              Color(0xFF2E5A44),

              Color(0xFF18392B),
            ],
          ),
        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding:
                  EdgeInsets.all(25),

              child: Container(

                padding:
                    EdgeInsets.all(25),

                decoration:
                    BoxDecoration(

                  color:
                      Colors.white
                          .withOpacity(
                    0.12,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  border: Border.all(

                    color:
                        Colors.white24,
                  ),
                ),

                child: Column(

                  children: [

                    // 🔥 ICON

                    Container(

                      padding:
                          EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white24,

                        shape:
                            BoxShape.circle,
                      ),

                      child: Icon(

                        Icons.person_add,

                        color:
                            Colors.white,

                        size: 55,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔥 TITLE

                    Text(

                      "Créer un compte",

                      style: TextStyle(

                        color:
                            Colors.white,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(

                      "Inscription sécurisée",

                      style: TextStyle(

                        color:
                            Colors.white70,

                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 35),

                    // 👤 NOM

                    buildInput(

                      controller:
                          nomController,

                      hint:
                          "Nom complet",

                      icon:
                          Icons.person,
                    ),

                    SizedBox(height: 18),

                    // 📧 EMAIL

                    buildInput(

                      controller:
                          emailController,

                      hint:
                          "Adresse email",

                      icon:
                          Icons.email,
                    ),

                    SizedBox(height: 18),

                    // 📞 PHONE

                    buildInput(

                      controller:
                          telephoneController,

                      hint:
                          "Téléphone",

                      icon:
                          Icons.phone,
                    ),

                    SizedBox(height: 18),

                    // 🔒 PASSWORD

                    TextField(

                      controller:
                          passwordController,

                      obscureText:
                          hidePassword,

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          InputDecoration(

                        hintText:
                            "Mot de passe",

                        hintStyle:
                            TextStyle(

                          color:
                              Colors.white70,
                        ),

                        prefixIcon:
                            Icon(

                          Icons.lock,

                          color:
                              Colors.white,
                        ),

                        suffixIcon:
                            IconButton(

                          icon: Icon(

                            hidePassword

                                ? Icons.visibility_off

                                : Icons.visibility,

                            color:
                                Colors.white,
                          ),

                          onPressed: () {

                            setState(() {

                              hidePassword =
                                  !hidePassword;
                            });
                          },
                        ),

                        filled: true,

                        fillColor:
                            Colors.white
                                .withOpacity(
                          0.15,
                        ),

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    // 👤 ROLE

                    DropdownButtonFormField(

                      value: role,

                      dropdownColor:
                          Color(
                        0xFF2E5A44,
                      ),

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          InputDecoration(

                        filled: true,

                        fillColor:
                            Colors.white
                                .withOpacity(
                          0.15,
                        ),

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),

                      items: [

                        DropdownMenuItem(

                          value: "user",

                          child: Text(
                            "Utilisateur",
                          ),
                        ),

                        DropdownMenuItem(

                          value: "admin",

                          child: Text(
                            "Admin",
                          ),
                        ),
                      ],

                      onChanged: (value) {

                        setState(() {

                          role = value!;
                        });
                      },
                    ),

                    SizedBox(height: 30),

                    // 🔥 BUTTON

                    SizedBox(

                      width:
                          double.infinity,

                      height: 58,

                      child:
                          ElevatedButton(

                        onPressed:

                            isLoading

                                ? null

                                : register,

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.white,

                          foregroundColor:
                              Color(
                            0xFF2E5A44,
                          ),

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        child:

                            isLoading

                                ? CircularProgressIndicator()

                                : Text(

                                    "S'inscrire",

                                    style: TextStyle(

                                      fontSize: 18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),

                    SizedBox(height: 18),

                    // 🔙 LOGIN

                    TextButton(

                      onPressed: () {

                        Navigator.pop(
                          context,
                        );
                      },

                      child: Text(

                        "Déjà un compte ? Connexion",

                        style: TextStyle(

                          color:
                              Colors.white,

                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 INPUT DESIGN

  Widget buildInput({

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,
  }) {

    return TextField(

      controller: controller,

      style: TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: TextStyle(

          color: Colors.white70,
        ),

        prefixIcon: Icon(

          icon,

          color: Colors.white,
        ),

        filled: true,

        fillColor:
            Colors.white.withOpacity(
          0.15,
        ),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}