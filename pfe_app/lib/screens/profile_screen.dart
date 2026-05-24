import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/objet.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  // =========================
  // USER INFOS
  // =========================

  String nom = "Utilisateur";
  String email = "";
  String telephone = "";

  // =========================
  // PROFILE IMAGE
  // =========================

  File? image;

  String profileImage = "";

  // =========================
  // STATS
  // =========================

  int total = 0;
  int retrouves = 0;
  int enCours = 0;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {

    super.initState();

    loadUser();

    loadStats();
  }

  // =========================
  // LOAD USER
  // =========================

  void loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      nom =
          prefs.getString("nom")
          ?? "Utilisateur";

      email =
          prefs.getString("email")
          ?? "";

      telephone =
          prefs.getString("telephone")
          ?? "";

      profileImage =
          prefs.getString("profile_image")
          ?? "";

      String? path =
          prefs.getString(
            "profile_image_$nom",
          );

      if (path != null) {

        image = File(path);
      }
    });
  }

  // =========================
  // LOAD STATS
  // =========================

  void loadStats() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    List<Objet> objets =
        await ApiService.fetchObjets();

    final myObjets =
        objets.where(
          (o) =>
              o.user.toString()
              == userId,
        ).toList();

    setState(() {

      total = myObjets.length;

      retrouves = myObjets
          .where(
            (o) =>
                o.statut
                    .toLowerCase()
                    == "trouvé",
          )
          .length;

      enCours = myObjets
          .where(
            (o) =>
                o.statut
                    .toLowerCase()
                    == "perdu",
          )
          .length;
    });
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future pickImage() async {

    final picked =
        await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      setState(() {

        image = File(picked.path);
      });

      final prefs =
          await SharedPreferences.getInstance();

      prefs.setString(
        "profile_image_$nom",
        picked.path,
      );
    }
  }

  // =========================
  // LOGOUT
  // =========================

  void logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    await http.post(

      Uri.parse(
        "http://192.168.80.68:8000/api/logout/",
      ),

      body: {
        "user_id": userId,
      },
    );

    await prefs.remove("isLoggedIn");

    Navigator.pushNamedAndRemoveUntil(

      context,

      '/login',

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

      body: Column(

        children: [

          // =========================
          // HEADER
          // =========================

          Stack(

            clipBehavior: Clip.none,

            children: [

              Container(

                height: 110,

                decoration: BoxDecoration(

                  gradient: LinearGradient(

                    colors: [

                      Color(0xFF3E6F55),

                      Color(0xFF2E5D46),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.vertical(

                    bottom:
                        Radius.circular(35),
                  ),
                ),

                child: SafeArea(

                  child: Padding(

                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 15,
                    ),

                    child: Row(

                      children: [

                        IconButton(

                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),

                          onPressed: () {

                            Navigator.pushNamed(
                              context,
                              '/home',
                            );
                          },
                        ),

                        Spacer(),

                        Text(

                          "Mon Profil",

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),

              // =========================
              // AVATAR
              // =========================

              Positioned(

                bottom: -30,

                left: 0,

                right: 0,

                child: Center(

                  child: GestureDetector(

                    onTap: pickImage,

                    child: Container(

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,

                        boxShadow: [

                          BoxShadow(

                            color: Colors.black26,

                            blurRadius: 10,

                            offset: Offset(0, 5),
                          )
                        ],
                      ),

                      child: CircleAvatar(

                        radius: 38,

                        backgroundColor:
                            Colors.white,

                        child: CircleAvatar(

                          radius: 34,

                          backgroundColor:
                              Colors.orange,

                          backgroundImage:
                              image != null
                                  ? FileImage(image!)
                                  : null,

                          child: image == null

                              ? Icon(

                                  Icons.person,

                                  size: 50,

                                  color: Colors.white,
                                )

                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 35),

          // =========================
          // USER INFOS
          // =========================

          Text(

            nom,

            style: TextStyle(

              fontSize: 20,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(

            email,

            style: TextStyle(

              color: Colors.grey,

              fontSize: 14,
            ),
          ),

          SizedBox(height: 5),

          Text(

            telephone,

            style: TextStyle(

              color: Color(0xFF3E6F55),

              fontWeight:
                  FontWeight.w500,
            ),
          ),

          SizedBox(height: 25),

          // =========================
          // STATS
          // =========================

          Container(

            margin:
                EdgeInsets.symmetric(
              horizontal: 25,
            ),

            padding:
                EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(20),

              boxShadow: [

                BoxShadow(

                  color: Colors.black12,

                  blurRadius: 10,

                  offset: Offset(0, 5),
                ),
              ],
            ),

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [

                statItem(

                  "$total",

                  "Publiés",

                  Icons.upload_file,
                ),

                divider(),

                statItem(

                  "$retrouves",

                  "Retrouvés",

                  Icons.check_circle,
                ),

                divider(),

                statItem(

                  "$enCours",

                  "En cours",

                  Icons.access_time,
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          // =========================
          // MENU
          // =========================

          Expanded(

            child: ListView(

              padding:
                  EdgeInsets.symmetric(
                horizontal: 20,
              ),

              children: [

                menuItem(

                  Icons.description,

                  "Mes publications",

                  () {

                    Navigator.pushNamed(

                      context,

                      '/mes-publications',
                    );
                  },
                ),

                menuItem(

                  Icons.edit,

                  "Modifier le profil",

                  () {

                    Navigator.pushNamed(

                      context,

                      '/edit-profile',
                    ).then((_) {

                      loadUser();
                    });
                  },
                ),

                menuItem(

                  Icons.notifications,

                  "Notifications",

                  () {

                    Navigator.pushNamed(

                      context,

                      '/notifications',
                    );
                  },
                ),

                menuItem(

                  Icons.lock,

                  "Sécurité",

                  () {

                    Navigator.pushNamed(

                      context,

                      '/change-password',
                    );
                  },
                ),

                menuItem(

                  Icons.logout,

                  "Se déconnecter",

                  logout,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // =========================
  // DIVIDER
  // =========================

  Widget divider() {

    return Container(

      height: 40,

      width: 1,

      color: Colors.grey[300],
    );
  }

  // =========================
  // STATS ITEM
  // =========================

  Widget statItem(

    String number,

    String label,

    IconData icon,

  ) {

    return Column(

      children: [

        Icon(

          icon,

          color: Color(0xFF3E6F55),

          size: 22,
        ),

        SizedBox(height: 5),

        Text(

          number,

          style: TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,

            color: Color(0xFF3E6F55),
          ),
        ),

        SizedBox(height: 2),

        Text(

          label,

          style: TextStyle(

            color: Colors.grey,

            fontSize: 12,
          ),
        )
      ],
    );
  }

  // =========================
  // MENU ITEM
  // =========================

  Widget menuItem(

    IconData icon,

    String text,

    VoidCallback onTap,

  ) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: EdgeInsets.only(
          bottom: 15,
        ),

        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),

          boxShadow: [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 8,

              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Row(

          children: [

            Container(

              padding: EdgeInsets.all(12),

              decoration: BoxDecoration(

                color:
                    Color(0xFF3E6F55)
                        .withOpacity(0.1),

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(

                icon,

                color: Color(0xFF3E6F55),
              ),
            ),

            SizedBox(width: 15),

            Expanded(

              child: Text(

                text,

                style: TextStyle(

                  fontSize: 15,

                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            Icon(

              Icons.arrow_forward_ios,

              size: 16,

              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}