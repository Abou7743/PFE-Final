import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'package:shared_preferences/shared_preferences.dart';

class MesFavorisScreen
    extends StatefulWidget {

  @override
  State<MesFavorisScreen>
      createState() =>
          _MesFavorisScreenState();
}

class _MesFavorisScreenState
    extends State<MesFavorisScreen> {

  // =========================
  // VARIABLES
  // =========================

  List favoris = [];

  bool loading = true;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {

    super.initState();

    loadFavoris();
  }

  // =========================
  // LOAD FAVORIS
  // =========================

  Future loadFavoris() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final response = await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/mes-favoris/$userId/",
      ),
    );

    setState(() {

      favoris =
          jsonDecode(response.body);

      loading = false;
    });
  }

  // =========================
  // ICON CATEGORIE
  // =========================

  IconData categoryIcon(
      String categorie) {

    switch (
        categorie.toLowerCase()) {

      case "telephone":

        return Icons.phone_android;

      case "sac":

        return Icons.work;

      case "cle":

        return Icons.key;

      case "portefeuille":

        return Icons.wallet;

      case "montre":

        return Icons.watch;

      default:

        return Icons.inventory_2;
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F7F5),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            Color(0xFF3E6F55),

        title: Column(

          children: [

            Text(

              "Mes Favoris",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 20,
              ),
            ),

            SizedBox(height: 2),

            Text(

              "Objets enregistrés ❤️",

              style: TextStyle(

                fontSize: 11,

                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: loading

          ? Center(

              child:
                  CircularProgressIndicator(

                color:
                    Color(0xFF3E6F55),
              ),
            )

          : favoris.isEmpty

              // =========================
              // EMPTY
              // =========================

              ? Center(

                  child: Column(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Container(

                        padding:
                            EdgeInsets.all(
                          25,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              Color(0xFFE8F1EC),

                          shape:
                              BoxShape.circle,
                        ),

                        child: Icon(

                          Icons.favorite_border,

                          size: 75,

                          color:
                              Color(0xFF3E6F55),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(

                        "Aucun favori",

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(

                        "Les objets ajoutés en favoris\napparaîtront ici",

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(

                          color: Colors.grey,

                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )

              // =========================
              // LIST
              // =========================

              : ListView.builder(

                  padding:
                      EdgeInsets.all(16),

                  itemCount:
                      favoris.length,

                  itemBuilder:
                      (context, index) {

                    final fav =
                        favoris[index];

                    return Container(

                      margin:
                          EdgeInsets.only(
                        bottom: 18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.black12,

                            blurRadius: 12,

                            offset:
                                Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Padding(

                        padding:
                            EdgeInsets.all(
                          18,
                        ),

                        child: Row(

                          children: [

                            // =========================
                            // ICON
                            // =========================

                            Container(

                              width: 70,

                              height: 70,

                              decoration:
                                  BoxDecoration(

                                color:
                                    Color(
                                  0xFFE8F1EC,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Icon(

                                categoryIcon(
                                  fav['categorie'] ??
                                      "autre",
                                ),

                                size: 35,

                                color:
                                    Color(
                                  0xFF3E6F55,
                                ),
                              ),
                            ),

                            SizedBox(width: 16),

                            // =========================
                            // CONTENT
                            // =========================

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    fav['titre'] ??
                                        "",

                                    style: TextStyle(

                                      fontSize: 18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Text(

                                    fav['description'] ??
                                        "",

                                    maxLines: 2,

                                    overflow:
                                        TextOverflow.ellipsis,

                                    style: TextStyle(

                                      color:
                                          Colors.grey[
                                              700],

                                      fontSize: 14,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  Row(

                                    children: [

                                      Container(

                                        padding:
                                            EdgeInsets.symmetric(

                                          horizontal: 12,

                                          vertical: 6,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              Color(
                                            0xFFE8F1EC,
                                          ),

                                          borderRadius:
                                              BorderRadius.circular(
                                            30,
                                          ),
                                        ),

                                        child: Text(

                                          fav['categorie'] ??
                                              "Objet",

                                          style: TextStyle(

                                            color:
                                                Color(
                                              0xFF3E6F55,
                                            ),

                                            fontWeight:
                                                FontWeight.bold,

                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                      Spacer(),

                                      Icon(

                                        Icons.favorite,

                                        color:
                                            Colors.red,

                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}