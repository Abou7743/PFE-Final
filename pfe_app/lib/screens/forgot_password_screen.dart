import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

import 'reset_password_screen.dart';

class ForgotPasswordScreen
    extends StatefulWidget {

  @override
  State<ForgotPasswordScreen>
      createState() =>
          _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      phoneController =
      TextEditingController();

  String method = "email";

  bool loading = false;

  // =========================
  // SEND OTP
  // =========================

  Future sendOtp() async {

    setState(() {
      loading = true;
    });

    final response =
        await http.post(

      Uri.parse(
        "http://192.168.80.68:8000/api/send-otp/",
      ),

      body: {

        "method": method,

        "email":
            emailController.text,

        "telephone":
            phoneController.text,
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

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              ResetPasswordScreen(),
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

                      "Mot de passe oublié",

                      style: TextStyle(

                        color:
                            Colors.white,

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30),

                    DropdownButtonFormField(

                      value: method,

                      dropdownColor:
                          Color(
                        0xFF2E5A44,
                      ),

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          inputDecoration(),

                      items: [

                        DropdownMenuItem(

                          value:
                              "email",

                          child: Text(
                            "Email",
                          ),
                        ),

                        DropdownMenuItem(

                          value:
                              "telephone",

                          child: Text(
                            "Téléphone",
                          ),
                        ),
                      ],

                      onChanged: (value) {

                        setState(() {

                          method = value!;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    if (method ==
                        "email")

                      TextField(

                        controller:
                            emailController,

                        style: TextStyle(
                          color:
                              Colors.white,
                        ),

                        decoration:
                            inputDecoration(
                          hint:
                              "Votre email",
                        ),
                      ),

                    if (method ==
                        "telephone")

                      TextField(

                        controller:
                            phoneController,

                        style: TextStyle(
                          color:
                              Colors.white,
                        ),

                        decoration:
                            inputDecoration(
                          hint:
                              "Votre téléphone",
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
                                : sendOtp,

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

                                    "Continuer",

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