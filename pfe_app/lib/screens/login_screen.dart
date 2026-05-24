import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_screen.dart';

import 'package:http/http.dart'
    as http;

class LoginScreen
    extends StatefulWidget {

  @override
  _LoginScreenState createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  bool hidePassword = true;

  bool isLoading = false;

  // 🔥 LOGIN

  void login() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response =
          await http.post(

            //Uri.parse(
              //"http://127.0.0.1:8000/api/login/",
            //),
            Uri.parse(
              "http://192.168.80.68:8000/api/login/",
            ),

        headers: {
          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "email":
              emailController.text
                  .trim(),

          "password":
              passwordController.text
                  .trim(),
        }),
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

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        final prefs =
            await SharedPreferences
                .getInstance();

        await prefs.setString(
          "token",
          data['token'],
        );

        await prefs.setString(
          "id",
          data['id'].toString(),
        );

        await prefs.setString(
          "nom",
          data['nom'],
        );

        await prefs.setString(
          "email",
          data['email'],
        );

        await prefs.setString(
          "telephone",
          data['telephone'] ?? "",
        );

        await prefs.setString(
          "role",
          data['role'],
        );

        await prefs.setBool(
          "isLoggedIn",
          true,
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            backgroundColor:
                Colors.green,

            content: Text(
              "Connexion réussie ✅",
            ),
          ),
        );

        if (data['role']
                .toString()
                .toLowerCase() ==

            "admin") {

          Navigator.pushReplacementNamed(
            context,
            '/admin',
          );

        } else {

          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
        }

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            backgroundColor:
                Colors.red,

            content: Text(
              "Email ou mot de passe incorrect ❌",
            ),
          ),
        );
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

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

                        Icons.lock,

                        color:
                            Colors.white,

                        size: 55,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔥 TITLE

                    Text(

                      "Bienvenue 👋",

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

                      "Connexion sécurisée",

                      style: TextStyle(

                        color:
                            Colors.white70,

                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 35),

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

                                : login,

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

                                    "Se connecter",

                                    style: TextStyle(

                                      fontSize: 18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),

                    SizedBox(height: 18),

                    // 🔐 FORGOT PASSWORD
// 🔐 FORGOT PASSWORD

TextButton(

  onPressed: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) =>
            ForgotPasswordScreen(),
      ),
    );
  },

  child: Text(

    "Mot de passe oublié ?",

    style: TextStyle(

      color: Colors.white70,

      fontSize: 14,
    ),
  ),
),

SizedBox(height: 5),

SizedBox(height: 5),

                    // 🔙 REGISTER

                    TextButton(

                      onPressed: () {

                        Navigator.pushNamed(
                          context,
                          '/register',
                        );
                      },

                      child: Text(

                        "Créer un compte",

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