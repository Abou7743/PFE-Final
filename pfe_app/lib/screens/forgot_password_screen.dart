import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:http/http.dart'
    as http;

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

  final TextEditingController
      otpController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  String method = "email";

  bool otpSent = false;

  bool otpVerified = false;

  bool loading = false;

  int seconds = 30;

  Timer? timer;

  bool canResend = false;

  void startTimer() {

  seconds = 30;

  canResend = false;

  timer?.cancel();

  timer = Timer.periodic(

    Duration(seconds: 1),

    (timer) {

      if (seconds > 0) {

        setState(() {

          seconds--;
        });

      } else {

        setState(() {

          canResend = true;
        });

        timer.cancel();
      }
    },
  );
}

  // 🔥 SEND OTP

  Future sendOtp() async {

    setState(() {
      loading = true;
    });

    final response =
        await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/send-otp/",
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

      setState(() {
        otpSent = true;
      });
      startTimer();
    }
  }

  // 🔥 VERIFY OTP

  Future verifyOtp() async {

    setState(() {
      loading = true;
    });

    final response =
        await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/verify-otp/",
      ),

      body: {

        "otp":
            otpController.text,
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

      setState(() {
        otpVerified = true;
      });
    }
  }

  // 🔥 RESET PASSWORD

  Future resetPassword() async {

    setState(() {
      loading = true;
    });

    final response =
        await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/reset-password/",
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

      Navigator.pop(context);
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

                    // 🔥 METHOD

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

                    // 📧 EMAIL

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

                    // 📱 PHONE

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

                    SizedBox(height: 25),

                    // 🔥 SEND OTP

                    if (!otpSent)

                      buildButton(

                        text:
                            "Envoyer OTP",

                        onPressed:
                            sendOtp,
                      ),

                    // 🔥 OTP

                    if (otpSent) ...[

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

                      if (!otpVerified)

                        buildButton(

                          text:
                              "Vérifier OTP",

                          onPressed:
                              verifyOtp,
                        ),

                        SizedBox(height: 15),

canResend

? TextButton(

    onPressed: sendOtp,

    child: Text(

      "Renvoyer le code",

      style: TextStyle(

        color: Colors.white,

        fontSize: 16,

        fontWeight: FontWeight.bold,
      ),
    ),
  )

: Text(

    "Renvoyer dans 00:$seconds",

    style: TextStyle(

      color: Colors.white70,
    ),
  ),
                    ],

                    // 🔥 NEW PASSWORD

                    if (otpVerified) ...[

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

                      buildButton(

                        text:
                            "Changer mot de passe",

                        onPressed:
                            resetPassword,
                      ),
                    ],

                    if (loading)

                      Padding(

                        padding:
                            EdgeInsets.all(
                          20,
                        ),

                        child:
                            CircularProgressIndicator(
                          color:
                              Colors.white,
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

  // 🔥 INPUT

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

  // 🔥 BUTTON

  Widget buildButton({

    required String text,

    required VoidCallback
        onPressed,
  }) {

    return SizedBox(

      width: double.infinity,

      height: 55,

      child: ElevatedButton(

        onPressed: onPressed,

        style:
            ElevatedButton.styleFrom(

          backgroundColor:
              Colors.white,

          foregroundColor:
              Color(0xFF2E5A44),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
        ),

        child: Text(

          text,

          style: TextStyle(

            fontSize: 17,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}