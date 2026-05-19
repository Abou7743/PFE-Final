import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../models/objet.dart';

import 'detail_screen.dart';
import 'notifications_screen.dart';
import 'mes_favoris_screen.dart';
import 'conversations_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  // =========================
  // VARIABLES
  // =========================

  String nom = "Utilisateur";

  String selectedCategory = "Tout";

  late Future<List<Objet>>
      objetsFuture;

  TextEditingController
      searchController =
          TextEditingController();

  String searchText = "";

  int currentIndex = 0;

  int documentBadge = 0;

  int notificationCount = 0;

  int messageCount = 0;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {

    super.initState();

    loadUser();

    loadCounts();

    loadDocumentBadge();

    objetsFuture =
        ApiService.fetchObjets();
  }

  // =========================
  // DOCUMENT BADGE
  // =========================

  void loadDocumentBadge() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      documentBadge =
          prefs.getInt(
            "documentBadge",
          ) ?? 0;
    });
  }

  // =========================
  // LOAD COUNTS
  // =========================

  Future loadCounts() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final notifResponse =
        await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/notifications-count/$userId/",
      ),
    );

    final msgResponse =
        await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/messages-count/$userId/",
      ),
    );

    setState(() {

      notificationCount =
          jsonDecode(
            notifResponse.body,
          )['count'];

      messageCount =
          jsonDecode(
            msgResponse.body,
          )['count'];
    });
  }

  // =========================
  // LOAD USER
  // =========================

  void loadUser() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    setState(() {

      nom =
          prefs.getString("nom")
          ?? "Utilisateur";
    });
  }

  // =========================
  // LOGOUT
  // =========================

  void logout() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.clear();

    Navigator.pushNamedAndRemoveUntil(

      context,

      '/',

      (route) => false,
    );
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F7F5),

      // =========================
      // BODY
      // =========================

      body: Column(

        children: [

          // =========================
          // HEADER
          // =========================

          Container(

            padding:
                EdgeInsets.fromLTRB(
              16,
              30,
              16,
              12,
            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Color(0xFF3E6F55),

                  Color(0xFF2D5A44),
                ],
              ),

              borderRadius:
                  BorderRadius.vertical(

                bottom:
                    Radius.circular(18),
              ),

              boxShadow: [

                BoxShadow(

                  color: Colors.black26,

                  blurRadius: 10,

                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: SafeArea(

              child: Row(

                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  // USER

                  Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(

                        "Bonjour 👋",

                        style: TextStyle(

                          color:
                              Colors.white70,

                          fontSize: 12,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(

                        nom,

                        style: TextStyle(

                          color:
                              Colors.white,

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // ACTIONS

                  Row(

                    children: [

                      headerButton(

                        icon:
                            Icons.favorite,

                        color:
                            Colors.red,

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  MesFavorisScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 8),

                      badgeButton(

                        icon:
                            Icons.notifications,

                        count:
                            notificationCount,

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  NotificationsScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 8),

                      badgeButton(

                        icon:
                            Icons.chat_bubble,

                        count:
                            messageCount,

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  ConversationsScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 8),

                      headerButton(

                        icon:
                            Icons.logout,

                        color:
                            Colors.white,

                        onTap: logout,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          // =========================
          // SEARCH BAR
          // =========================

          Padding(

            padding:
                EdgeInsets.symmetric(
              horizontal: 18,
            ),

            child: Container(

              decoration: BoxDecoration(

                boxShadow: [

                  BoxShadow(

                    color: Colors.black12,

                    blurRadius: 8,

                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(

                controller:
                    searchController,

                onChanged: (value) {

                  setState(() {

                    searchText = value;
                  });
                },

                decoration:
                    InputDecoration(

                  hintText:
                      "Rechercher...",

                  prefixIcon:
                      Icon(Icons.search),

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          // =========================
          // CATEGORIES
          // =========================

          SingleChildScrollView(

            scrollDirection:
                Axis.horizontal,

            child: Row(

              children: [

                chip("Tout"),

                chip("Documents"),

                chip("Téléphones"),

                chip("Sac"),

                chip("Clé"),

                chip("Perdu"),

                chip("Trouvé"),
              ],
            ),
          ),

          SizedBox(height: 8),

          // =========================
          // BUTTONS
          // =========================

          actionButton(

            icon:
                Icons.badge_outlined,

            text:
                "Publier Document",

            onTap: () async {

              final result =
                  await Navigator.pushNamed(

                context,

                '/add-document',
              );

              if (result == true) {

  final prefs =
      await SharedPreferences.getInstance();

  int current =
      prefs.getInt(
        "documentBadge",
      ) ?? 0;

  await prefs.setInt(

    "documentBadge",

    current + 1,
  );

  loadDocumentBadge();

  setState(() {

    objetsFuture =
        ApiService.fetchObjets();
  });
}
            },
          ),

          actionButton(

            icon:
                Icons.search,

            text:
                "Rechercher Document",

            onTap: () {

              Navigator.pushNamed(

                context,

                '/search-document',
              );
            },
          ),

          actionButton(

            icon:
                Icons.document_scanner,

            text:
                "Scanner IA",

            onTap: () {

              Navigator.pushNamed(

                context,

                '/ocr-document',
              );
            },
          ),

          SizedBox(height: 5),

          // =========================
          // LISTE OBJETS
          // =========================

          Expanded(

            child:
                FutureBuilder<List<Objet>>(

              future:
                  objetsFuture,

              builder:
                  (context, snapshot) {

                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {

                  return Center(

                    child: Text(
                      "Erreur 😢",
                    ),
                  );
                }

                final objets =
                    snapshot.data ??
                        [];

                objets.sort(

                  (a, b) =>
                      b.id.compareTo(
                    a.id,
                  ),
                );

                final filteredObjets =
                    objets.where((obj) {

                  bool matchCategory =

                      selectedCategory ==
                              "Tout"

                          ? true

                          : selectedCategory ==
                                  "Documents"

                              ? obj.categorie
                                      .toLowerCase() ==
                                  "document"

                              : selectedCategory ==
                                      "Téléphones"

                                  ? obj.categorie
                                          .toLowerCase() ==
                                      "telephone"

                                  : selectedCategory ==
                                          "Sac"

                                      ? obj.categorie
                                              .toLowerCase() ==
                                          "sac"

                                      : selectedCategory ==
                                              "Clé"

                                          ? obj.categorie
                                                  .toLowerCase() ==
                                              "cle"

                                          : selectedCategory ==
                                                  "Perdu"

                                              ? obj.statut
                                                      .toLowerCase() ==
                                                  "perdu"

                                              : selectedCategory ==
                                                      "Trouvé"

                                                  ? obj.statut
                                                          .toLowerCase() ==
                                                      "trouvé"

                                                  : true;

                  bool matchSearch =

                      obj.titre
                          .toLowerCase()
                          .contains(
                            searchText
                                .toLowerCase(),
                          )

                      ||

                      obj.lieu
                          .toLowerCase()
                          .contains(
                            searchText
                                .toLowerCase(),
                          );

                  return matchCategory &&
                      matchSearch;

                }).toList();

                if (filteredObjets
                    .isEmpty) {

                  return Center(

                    child: Text(
                      "Aucun objet 😢",
                    ),
                  );
                }

                return ListView(

                  children: [

                    Padding(

                      padding:
                          EdgeInsets.all(15),

                      child: Text(

                        "Publications récentes",

                        style: TextStyle(

                          fontSize: 16,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    ...filteredObjets
                        .map(

                      (obj) => itemCard(
                        context,
                        obj,
                      ),

                    ).toList(),
                  ],
                );
              },
            ),
          )
        ],
      ),

      // =========================
      // FLOAT BUTTON
      // =========================

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            Color(0xFF3E6F55),

        elevation: 8,

        child: Icon(Icons.add),

        onPressed: () async {

          final result =
              await Navigator.pushNamed(

            context,

            '/add-objet',
          );

          if (result == true) {

            setState(() {

              objetsFuture =
                  ApiService.fetchObjets();
            });
          }
        },
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex:
            currentIndex,

        type:
            BottomNavigationBarType
                .fixed,

        selectedItemColor:
            Color(0xFF3E6F55),

        elevation: 10,

        onTap: (index) async {

          setState(() {

            currentIndex = index;
          });

          if (index == 1) {

            Navigator.pushNamed(
              context,
              '/search',
            );

          }

          else if (index == 2) {

            final prefs =
                await SharedPreferences
                    .getInstance();

            await prefs.setInt(
              "documentBadge",
              0,
            );

            loadDocumentBadge();

            Navigator.pushNamed(
              context,
              '/documents',
            );
          }

          else if (index == 3) {

            Navigator.pushNamed(
              context,
              '/profile',
            );
          }
        },

        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Recherche",
          ),

          BottomNavigationBarItem(

            icon: Stack(

              children: [

                Icon(Icons.description),

                if (documentBadge > 0)

                  Positioned(

                    right: 0,

                    child: Container(

                      padding:
                          EdgeInsets.all(4),

                      decoration: BoxDecoration(

                        color: Colors.red,

                        shape: BoxShape.circle,
                      ),

                      child: Text(

                        documentBadge
                            .toString(),

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 8,
                        ),
                      ),
                    ),
                  )
              ],
            ),

            label: "Docs",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  // =========================
  // HEADER BUTTON
  // =========================

  Widget headerButton({

    required IconData icon,

    required Color color,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: EdgeInsets.all(10),

        decoration: BoxDecoration(

          color: Colors.white24,

          borderRadius:
              BorderRadius.circular(14),
        ),

        child: Icon(

          icon,

          color: color,

          size: 20,
        ),
      ),
    );
  }

  // =========================
  // BADGE BUTTON
  // =========================

  Widget badgeButton({

    required IconData icon,

    required int count,

    required VoidCallback onTap,

  }) {

    return Stack(

      children: [

        headerButton(

          icon: icon,

          color: Colors.white,

          onTap: onTap,
        ),

        if (count > 0)

          Positioned(

            right: 0,

            top: 0,

            child: Container(

              padding:
                  EdgeInsets.all(4),

              decoration: BoxDecoration(

                color: Colors.red,

                shape: BoxShape.circle,
              ),

              child: Text(

                count.toString(),

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 9,
                ),
              ),
            ),
          )
      ],
    );
  }

  // =========================
  // CATEGORY CHIP
  // =========================

  Widget chip(
    String text,
  ) {

    bool selected =
        selectedCategory == text;

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 5,
      ),

      child: GestureDetector(

        onTap: () {

          setState(() {

            selectedCategory =
                text;
          });
        },

        child: AnimatedContainer(

          duration:
              Duration(milliseconds: 300),

          padding:
              EdgeInsets.symmetric(

            horizontal: 16,

            vertical: 10,
          ),

          decoration: BoxDecoration(

            color:

                selected

                    ? Color(0xFF3E6F55)

                    : Colors.white,

            borderRadius:
                BorderRadius.circular(
              20,
            ),

            boxShadow: [

              BoxShadow(

                color: Colors.black12,

                blurRadius: 5,

                offset: Offset(0, 2),
              ),
            ],
          ),

          child: Text(

            text,

            style: TextStyle(

              color:

                  selected

                      ? Colors.white

                      : Colors.black,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // ACTION BUTTON
  // =========================

  Widget actionButton({

    required IconData icon,

    required String text,

    required VoidCallback onTap,

  }) {

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 5,
      ),

      child: SizedBox(

        width: double.infinity,

        child: ElevatedButton.icon(

          onPressed: onTap,

          icon: Icon(icon),

          label: Text(text),

          style:
              ElevatedButton.styleFrom(

            backgroundColor:
                Color(0xFF3E6F55),

            elevation: 6,

            padding:
                EdgeInsets.symmetric(
              vertical: 12,
            ),

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // CARD
  // =========================

  Widget itemCard(

    BuildContext context,

    Objet obj,

  ) {

    return GestureDetector(

      onTap: () async {

        final result =
            await Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                DetailScreen(
              objet: obj,
            ),
          ),
        );

        if (result == true) {

          setState(() {

            objetsFuture =
                ApiService.fetchObjets();
          });
        }
      },

      child: Container(

        margin:
            EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),

        padding:
            EdgeInsets.all(12),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            20,
          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 8,

              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(

          children: [

            ClipRRect(

              borderRadius:
                  BorderRadius.circular(
                15,
              ),

              child:

                  obj.imageUrl != null

                      ? Image.network(

                          obj.imageUrl!,

                          width: 65,

                          height: 65,

                          fit: BoxFit.cover,
                        )

                      : Container(

                          width: 65,

                          height: 65,

                          color:
                              Colors.grey[200],

                          child: Icon(
                            Icons.image,
                          ),
                        ),
            ),

            SizedBox(width: 12),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Row(

                    children: [

                      Expanded(

                        child: Text(

                          obj.titre,

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 15,
                          ),
                        ),
                      ),

                      Container(

                        padding:
                            EdgeInsets.symmetric(

                          horizontal: 10,

                          vertical: 4,
                        ),

                        decoration:
                            BoxDecoration(

                          color:

                              obj.statut
                                          .toLowerCase() ==
                                      "perdu"

                                  ? Colors.red

                                  : Colors.green,

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                        child: Text(

                          obj.statut,

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Row(

                    children: [

                      Icon(

                        Icons.location_on,

                        size: 15,

                        color: Colors.grey,
                      ),

                      SizedBox(width: 4),

                      Expanded(

                        child: Text(

                          obj.lieu,

                          style: TextStyle(

                            color:
                                Colors.grey[700],

                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  Row(

                    children: [

                      Icon(

                        Icons.phone,

                        size: 15,

                        color: Colors.grey,
                      ),

                      SizedBox(width: 4),

                      Text(

                        obj.telephone ?? "",

                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}