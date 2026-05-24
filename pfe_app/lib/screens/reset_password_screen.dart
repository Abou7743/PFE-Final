import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

class ResetPasswordScreen
    extends StatefulWidget {

  @override
  State<ResetPasswordScreen>
      createState() =>
          _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController
      otpController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  final TextEditingController
      confirmController =
      TextEditingController();

  bool loading = false;

  // =========================
  // RESET PASSWORD
  // =========================

  Future resetPassword() async {

    if (passwordController.text !=
        confirmController.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.red,

          content: Text(

            "Les mots de passe ne correspondent pas ❌",
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    final response =
        await http.post(

      Uri.parse(
        "http://192.168.80.68:8000/api/reset-password/",
      ),

      body: {

        "otp":
            otpController.text,

        "password":
            passwordController.text,
      },
    );

    final data =
        jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          data['message'],
        ),
      ),
    );

    if (data['success']) {

      Navigator.popUntil(

        context,

        (route) => route.isFirst,
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
                ),

                child: Column(

                  children: [

                    Icon(

                      Icons.lock_reset,

                      color:
                          Colors.white,

                      size: 70,
                    ),

                    SizedBox(height: 20),

                    Text(

                      "Changer mot de passe",

                      style: TextStyle(

                        color:
                            Colors.white,

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30),

                    TextField(

                      controller:
                          otpController,

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          inputDecoration(
                        hint:
                            "Code OTP",
                      ),
                    ),

                    SizedBox(height: 20),

                    TextField(

                      controller:
                          passwordController,

                      obscureText:
                          true,

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          inputDecoration(
                        hint:
                            "Nouveau mot de passe",
                      ),
                    ),

                    SizedBox(height: 20),

                    TextField(

                      controller:
                          confirmController,

                      obscureText:
                          true,

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          inputDecoration(
                        hint:
                            "Confirmer mot de passe",
                      ),
                    ),

                    SizedBox(height: 30),

                    SizedBox(

                      width:
                          double.infinity,

                      height: 55,

                      child:
                          ElevatedButton(

                        onPressed:

                            loading
                                ? null
                                : resetPassword,

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

                            loading

                                ? CircularProgressIndicator()

                                : Text(

                                    "Changer mot de passe",

                                    style: TextStyle(

                                      fontSize: 17,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT
  // =========================

  InputDecoration inputDecoration({

    String hint = "",
  }) {

    return InputDecoration(

      hintText: hint,

      hintStyle: TextStyle(
        color: Colors.white70,
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
    );
  }
}