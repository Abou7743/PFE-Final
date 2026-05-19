import 'package:flutter/material.dart';

import '../models/objet.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart'
    as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class DetailScreen
    extends StatefulWidget {

  final Objet objet;

  DetailScreen({
    required this.objet,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F6F8),

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // 📸 IMAGE HEADER

            Stack(

              children: [

                widget.objet.imageUrl != null

                    ? ClipRRect(

                        borderRadius:
                            BorderRadius.only(

                          bottomLeft:
                              Radius.circular(
                            30,
                          ),

                          bottomRight:
                              Radius.circular(
                            30,
                          ),
                        ),

                        child: Image.network(

                          widget.objet.imageUrl!,

                          width:
                              double.infinity,

                          height: 320,

                          fit: BoxFit.cover,
                        ),
                      )

                    : Container(

                        height: 320,

                        decoration:
                            BoxDecoration(

                          color:
                              Colors.grey[300],

                          borderRadius:
                              BorderRadius.only(

                            bottomLeft:
                                Radius.circular(
                              30,
                            ),

                            bottomRight:
                                Radius.circular(
                              30,
                            ),
                          ),
                        ),

                        child: Center(

                          child: Icon(

                            Icons.image,

                            size: 70,

                            color:
                                Colors.grey,
                          ),
                        ),
                      ),

                // 🔙 BACK BUTTON

                Positioned(

                  top: 50,
                  left: 15,

                  child: CircleAvatar(

                    backgroundColor:
                        Colors.black45,

                    child: IconButton(

                      icon: Icon(

                        Icons.arrow_back,

                        color:
                            Colors.white,
                      ),

                      onPressed: () {

                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                ),

                // ❤️ FAVORI

                Positioned(

                  top: 50,
                  right: 15,

                  child: CircleAvatar(

                    backgroundColor:
                        Colors.white,

                    child: IconButton(

                      onPressed:
                          addFavori,

                      icon: Icon(

                        isFavorite

                            ? Icons.favorite

                            : Icons.favorite_border,

                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(

              padding:
                  EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // 🔤 TITRE

                  Text(

                    widget.objet.titre,

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),

                  // 📍 LIEU

                  Row(

                    children: [

                      Icon(

                        Icons.location_on,

                        color:
                            Colors.red,
                      ),

                      SizedBox(width: 5),

                      Expanded(

                        child: Text(

                          widget.objet.lieu,

                          style: TextStyle(

                            fontSize: 16,

                            color:
                                Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // 🟢 STATUT

                  Container(

                    padding:
                        EdgeInsets.symmetric(

                      horizontal: 15,

                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(

                      color:

                          widget.objet
                                      .statut
                                      .toLowerCase() ==

                                  "perdu"

                              ? Colors.red

                              : Colors.green,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: Text(

                      widget.objet.statut,

                      style: TextStyle(

                        color:
                            Colors.white,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // 📝 DESCRIPTION CARD

                  Container(

                    width:
                        double.infinity,

                    padding:
                        EdgeInsets.all(18),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black12,

                          blurRadius: 8,

                          offset:
                              Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          "Description",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(

                          widget.objet
                              .description,

                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  // 🔥 ACTIONS

                  Text(

                    "Actions",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  GridView.count(

                    crossAxisCount: 2,

                    shrinkWrap: true,

                    physics:
                        NeverScrollableScrollPhysics(),

                    crossAxisSpacing: 15,

                    mainAxisSpacing: 15,

                    childAspectRatio: 2.5,

                    children: [

                      actionButton(

                        "📞 Appeler",

                        Colors.green,

                        callNumber,
                      ),

                      actionButton(

                        "💬 WhatsApp",

                        Colors.teal,

                        openWhatsApp,
                      ),

                      actionButton(

                        "📍 Carte",

                        Colors.orange,

                        () => openMap(
                          widget.objet.lieu,
                        ),
                      ),

                      actionButton(

                        "💬 Chat",

                        Colors.blue,

                        () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  ChatScreen(

                                receiverId:
                                    widget.objet.user,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ❤️ FAVORI

  Future addFavori() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final response =
        await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/favoris/",
      ),

      body: {

        "user": userId,

        "objet":
            widget.objet.id.toString(),
      },
    );

    final data =
        jsonDecode(response.body);

    setState(() {

      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          data['message'],
        ),
      ),
    );
  }

  // 🔘 ACTION BUTTON

  Widget actionButton(

    String text,

    Color color,

    VoidCallback onPressed,
  ) {

    return ElevatedButton(

      onPressed: onPressed,

      style:
          ElevatedButton.styleFrom(

        backgroundColor: color,

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
          fontSize: 15,
        ),
      ),
    );
  }

  // 📞 APPEL

  void callNumber() async {

    final phone =
        widget.objet.telephone ??
            "";

    final Uri url =
        Uri.parse("tel:$phone");

    await launchUrl(url);
  }

  // 💬 WHATSAPP

  void openWhatsApp() async {

    final phone =
        widget.objet.telephone ??
            "";

    final Uri url = Uri.parse(

      "https://wa.me/222$phone",
    );

    await launchUrl(

      url,

      mode:
          LaunchMode.externalApplication,
    );
  }

  // 📍 MAP

  void openMap(String lieu) async {

    final Uri url = Uri.parse(

      "https://www.google.com/maps/search/?api=1&query=$lieu",
    );

    await launchUrl(url);
  }
}