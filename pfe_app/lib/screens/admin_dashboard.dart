import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard
    extends StatefulWidget {

  @override
  _AdminDashboardState createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {

  String adminName = "Admin";

  int iaCount = 3;

  @override
  void initState() {

    super.initState();

    loadAdmin();

    loadMatchesCount();
  }

  // 👤 LOAD ADMIN

  loadAdmin() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      adminName =
          prefs.getString('nom') ??
              "Admin";
    });
  }

  // 🤖 IA MATCH COUNT

  loadMatchesCount() async {

    final matches =
        await fetchMatchesCount();

    setState(() {

      iaCount = matches;
    });
  }

  Future<int> fetchMatchesCount() async {

    return 3;
  }

  // 🚪 LOGOUT

  logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushReplacementNamed(

      context,

      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F6F8),

      body: Column(

        children: [

          // 🔹 HEADER

          Container(

            width: double.infinity,

            padding:
                EdgeInsets.fromLTRB(
              25,
              60,
              25,
              35,
            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Color(0xFF3E6F55),

                  Color(0xFF2E5A44),
                ],
              ),

              borderRadius:
                  BorderRadius.only(

                bottomLeft:
                    Radius.circular(35),

                bottomRight:
                    Radius.circular(35),
              ),
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

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

                            fontSize: 16,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(

                          adminName,

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 28,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Container(

                      decoration: BoxDecoration(

                        color: Colors.white24,

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: IconButton(

                        icon: Icon(

                          Icons.logout,

                          color: Colors.white,
                        ),

                        onPressed: () {

                          logout();
                        },
                      ),
                    )
                  ],
                ),

                SizedBox(height: 25),

                // 📊 STATS CARD

                Container(

                  padding:
                      EdgeInsets.all(18),

                  decoration:
                      BoxDecoration(

                    color: Colors.white24,

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,

                    children: [

                      statItem(

                        Icons.people,

                        "Users",

                        "120",
                      ),

                      statItem(

                        Icons.article,

                        "Logs",

                        "34",
                      ),

                      statItem(

                        Icons.psychology,

                        "IA",

                        "$iaCount",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          // 🔹 DASHBOARD

          Expanded(

            child: Padding(

              padding:
                  EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: GridView.count(

                crossAxisCount: 2,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                childAspectRatio: 1.05,

                children: [

                  adminCard(

                    context,

                    Icons.people_alt,

                    "Utilisateurs",

                    Colors.blue,
                  ),

                  adminCard(

                    context,

                    Icons.location_city,

                    "Centres",

                    Colors.orange,
                  ),

                  adminCard(

                    context,

                    Icons.map,

                    "Zones",

                    Colors.green,
                  ),

                  adminCard(

                    context,

                    Icons.article,

                    "Logs",

                    Colors.purple,
                  ),

                  adminCard(

                    context,

                    Icons.delete_outline,

                    "Contenus",

                    Colors.red,
                  ),

                  adminCard(

                    context,

                    Icons.psychology_alt,

                    "IA Match",

                    Colors.teal,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 📊 STATS ITEM

  Widget statItem(

    IconData icon,

    String title,

    String value,
  ) {

    return Column(

      children: [

        Icon(

          icon,

          color: Colors.white,

          size: 28,
        ),

        SizedBox(height: 8),

        Text(

          value,

          style: TextStyle(

            color: Colors.white,

            fontSize: 20,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        SizedBox(height: 3),

        Text(

          title,

          style: TextStyle(

            color: Colors.white70,

            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // 🔹 ADMIN CARD

  Widget adminCard(

    BuildContext context,

    IconData icon,

    String title,

    Color color,
  ) {

    return GestureDetector(

      onTap: () {

        if (title == "Utilisateurs") {

          Navigator.pushNamed(

            context,

            '/users-admin',
          );
        }

        else if (title == "Centres") {

          Navigator.pushNamed(

            context,

            '/centres-admin',
          );
        }

        else if (title == "Zones") {

          Navigator.pushNamed(

            context,

            '/zones-admin',
          );
        }

        else if (title == "Logs") {

          Navigator.pushNamed(

            context,

            '/logs-admin',
          );
        }

        else if (title == "Contenus") {

          Navigator.pushNamed(

            context,

            '/content-admin',
          );
        }

        else if (title == "IA Match") {

          Navigator.pushNamed(

            context,

            '/ia-admin',
          );
        }
      },

      child: Container(

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 10,

              offset: Offset(0, 5),
            ),
          ],
        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Stack(

              children: [

                Container(

                  padding:
                      EdgeInsets.all(18),

                  decoration:
                      BoxDecoration(

                    color:
                        color.withOpacity(
                      0.15,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(

                    icon,

                    size: 38,

                    color: color,
                  ),
                ),

                // 🔴 BADGE IA

                if (title == "IA Match")

                  Positioned(

                    right: 0,
                    top: 0,

                    child: Container(

                      padding:
                          EdgeInsets.all(
                        6,
                      ),

                      decoration:
                          BoxDecoration(

                        color: Colors.red,

                        shape:
                            BoxShape.circle,
                      ),

                      child: Text(

                        "$iaCount",

                        style: TextStyle(

                          color:
                              Colors.white,

                          fontSize: 11,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ],
            ),

            SizedBox(height: 18),

            Text(

              title,

              style: TextStyle(

                fontSize: 17,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}