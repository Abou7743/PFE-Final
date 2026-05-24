import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen
    extends StatefulWidget {

  @override
  _NotificationsScreenState createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  List notifications = [];

  @override
  void initState() {

    super.initState();

    loadNotifications();
  }

  // 🔔 LOAD NOTIFICATIONS

  Future<void> loadNotifications() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final response =
        await http.get(

      Uri.parse(
        "http://192.168.80.68:8000/api/notifications/$userId/",
      ),
    );

    if (response.statusCode == 200) {

      setState(() {

        notifications =
            jsonDecode(response.body);
      });
    }
  }

  // 🗑️ DELETE

  Future deleteNotification(
      int id) async {

    final response =
        await http.delete(

      Uri.parse(
        "http://192.168.80.68:8000/api/delete-notification/$id/",
      ),
    );

    final data =
        jsonDecode(response.body);

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          data['message'],
        ),
      ),
    );

    loadNotifications();
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

            padding:
                EdgeInsets.fromLTRB(
              20,
              55,
              20,
              30,
            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Color(0xFF3E6F55),

                  Color(0xFF2E5A44),
                ],
              ),

              borderRadius:
                  BorderRadius.vertical(

                bottom:
                    Radius.circular(35),
              ),
            ),

            child: Row(

              children: [

                Container(

                  decoration: BoxDecoration(

                    color: Colors.white24,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: IconButton(

                    icon: Icon(

                      Icons.arrow_back,

                      color: Colors.white,
                    ),

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ),

                SizedBox(width: 15),

                Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Notifications",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "${notifications.length} notification(s)",

                      style: TextStyle(

                        color:
                            Colors.white70,

                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          // 🔔 LISTE

          Expanded(

            child: notifications.isEmpty

                ? Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.notifications_off,

                          size: 90,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucune notification 🔔",

                          style: TextStyle(

                            fontSize: 18,

                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )

                : ListView.builder(

                    padding:
                        EdgeInsets.only(
                      bottom: 20,
                    ),

                    itemCount:
                        notifications.length,

                    itemBuilder:
                        (context, index) {

                      final notif =
                          notifications[index];

                      return Container(

                        margin:
                            EdgeInsets.symmetric(

                          horizontal: 18,

                          vertical: 8,
                        ),

                        padding:
                            EdgeInsets.all(15),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            22,
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

                        child: Row(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            // 🔔 ICON

                            Container(

                              padding:
                                  EdgeInsets.all(
                                12,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Color(0xFF3E6F55)
                                        .withOpacity(
                                  0.15,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  15,
                                ),
                              ),

                              child: Icon(

                                Icons.notifications_active,

                                color:
                                    Color(0xFF3E6F55),

                                size: 28,
                              ),
                            ),

                            SizedBox(width: 15),

                            // 📄 MESSAGE

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(

                                    notif['message'],

                                    style: TextStyle(

                                      fontSize: 16,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Row(

                                    children: [

                                      Icon(

                                        Icons.access_time,

                                        size: 15,

                                        color:
                                            Colors.grey,
                                      ),

                                      SizedBox(width: 5),

                                      Expanded(

                                        child: Text(

                                          notif['created_at'],

                                          style: TextStyle(

                                            color:
                                                Colors.grey,

                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // 🗑️ DELETE

                            IconButton(

                              icon: Icon(

                                Icons.delete,

                                color: Colors.red,
                              ),

                              onPressed: () async {

                                bool? confirm =
                                    await showDialog(

                                  context: context,

                                  builder: (context) {

                                    return AlertDialog(

                                      shape:
                                          RoundedRectangleBorder(

                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),

                                      title: Text(
                                        "Suppression",
                                      ),

                                      content: Text(
                                        "Supprimer cette notification ?",
                                      ),

                                      actions: [

                                        TextButton(

                                          onPressed: () {

                                            Navigator.pop(
                                              context,
                                              false,
                                            );
                                          },

                                          child: Text(
                                            "Annuler",
                                          ),
                                        ),

                                        TextButton(

                                          onPressed: () {

                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },

                                          child: Text(
                                            "Supprimer",
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {

                                  deleteNotification(
                                    notif['id'],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}