import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../models/objet.dart';

import 'edit_objet_screen.dart';

class MesPublicationsScreen
    extends StatefulWidget {

  @override
  _MesPublicationsScreenState createState() =>
      _MesPublicationsScreenState();
}

class _MesPublicationsScreenState
    extends State<MesPublicationsScreen> {

  String userId = "";

  Future<void> loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      userId =
          prefs.getString("id") ?? "";
    });
  }

  @override
  void initState() {

    super.initState();

    loadUser();
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

                      "Mes publications",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Objets et documents publiés 📦",

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

          // 🔹 LISTE

          Expanded(

            child:
                FutureBuilder<List<Objet>>(

              future:
                  ApiService.fetchObjets(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final objets =
                    snapshot.data!;

                final mesObjets =
                    objets.where(

                  (o) =>

                      o.user ==
                      int.parse(userId),

                ).toList();

                if (mesObjets.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.inventory_2,

                          size: 80,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucune publication 😢",

                          style: TextStyle(

                            fontSize: 18,

                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(

                  padding:
                      EdgeInsets.only(
                    bottom: 20,
                  ),

                  itemCount:
                      mesObjets.length,

                  itemBuilder:
                      (context, index) {

                    final obj =
                        mesObjets[index];

                    return Container(

                      margin:
                          EdgeInsets.symmetric(

                        horizontal: 18,

                        vertical: 8,
                      ),

                      decoration:
                          BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          25,
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

                        children: [

                          // 📸 IMAGE

                          ClipRRect(

                            borderRadius:
                                BorderRadius.only(

                              topLeft:
                                  Radius.circular(
                                25,
                              ),

                              topRight:
                                  Radius.circular(
                                25,
                              ),
                            ),

                            child:

                                obj.imageUrl != null

                                    ? Image.network(

                                        obj.imageUrl!,

                                        width:
                                            double.infinity,

                                        height: 190,

                                        fit: BoxFit.cover,
                                      )

                                    : Container(

                                        height: 190,

                                        color:
                                            Colors.grey[300],

                                        child: Center(

                                          child: Icon(

                                            Icons.image,

                                            size: 60,

                                            color:
                                                Colors.grey,
                                          ),
                                        ),
                                      ),
                          ),

                          Padding(

                            padding:
                                EdgeInsets.all(
                              15,
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                // 🔤 TITRE

                                Text(

                                  obj.titre,

                                  style: TextStyle(

                                    fontSize: 20,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 8),

                                // 📍 LIEU

                                Row(

                                  children: [

                                    Icon(

                                      Icons.location_on,

                                      color:
                                          Colors.red,

                                      size: 18,
                                    ),

                                    SizedBox(width: 5),

                                    Expanded(

                                      child: Text(

                                        obj.lieu,

                                        style: TextStyle(

                                          color:
                                              Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                // 📝 DESCRIPTION

                                Text(

                                  obj.description,

                                  style: TextStyle(

                                    fontSize: 15,

                                    color:
                                        Colors.grey[800],
                                  ),
                                ),

                                SizedBox(height: 15),

                                // 🟢 STATUT

                                Container(

                                  padding:
                                      EdgeInsets.symmetric(

                                    horizontal: 14,

                                    vertical: 6,
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
                                      30,
                                    ),
                                  ),

                                  child: Text(

                                    obj.statut,

                                    style: TextStyle(

                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // 🔥 ACTIONS

                                Row(

                                  children: [

                                    Expanded(

                                      child:
                                          ElevatedButton.icon(

                                        onPressed:
                                            () async {

                                          final result =
                                              await Navigator.push(

                                            context,

                                            MaterialPageRoute(

                                              builder: (_) =>
                                                  EditObjetScreen(

                                                objet: obj,
                                              ),
                                            ),
                                          );

                                          if (result == true) {

                                            setState(() {});
                                          }
                                        },

                                        icon: Icon(
                                          Icons.edit,
                                        ),

                                        label: Text(
                                          "Modifier",
                                        ),

                                        style:
                                            ElevatedButton.styleFrom(

                                          backgroundColor:
                                              Colors.blue,

                                          padding:
                                              EdgeInsets.symmetric(
                                            vertical: 13,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(

                                            borderRadius:
                                                BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10),

                                    Expanded(

                                      child:
                                          ElevatedButton.icon(

                                        onPressed:
                                            () async {

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
                                                  "Voulez-vous supprimer cette publication ?",
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

                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(

                                              SnackBar(

                                                content: Text(
                                                  "Publication supprimée ✅",
                                                ),
                                              ),
                                            );
                                          }
                                        },

                                        icon: Icon(
                                          Icons.delete,
                                        ),

                                        label: Text(
                                          "Supprimer",
                                        ),

                                        style:
                                            ElevatedButton.styleFrom(

                                          backgroundColor:
                                              Colors.red,

                                          padding:
                                              EdgeInsets.symmetric(
                                            vertical: 13,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(

                                            borderRadius:
                                                BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}