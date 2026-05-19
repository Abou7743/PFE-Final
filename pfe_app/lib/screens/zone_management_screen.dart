import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ZoneManagementScreen
    extends StatefulWidget {

  @override
  _ZoneManagementScreenState
      createState() =>

          _ZoneManagementScreenState();
}

class _ZoneManagementScreenState
    extends State<ZoneManagementScreen> {

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

                      "Zones 📍",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Gestion des zones",

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

          SizedBox(height: 15),

          // 📍 LISTE ZONES

          Expanded(

            child:
                FutureBuilder<List<dynamic>>(

              future:
                  ApiService.fetchZones(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final zones =
                    snapshot.data!;

                if (zones.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.map,

                          size: 90,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucune zone 📍",

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
                    bottom: 100,
                  ),

                  itemCount:
                      zones.length,

                  itemBuilder:
                      (context, index) {

                    final z =
                        zones[index];

                    return Container(

                      margin:
                          EdgeInsets.symmetric(

                        horizontal: 18,

                        vertical: 8,
                      ),

                      padding:
                          EdgeInsets.all(
                        15,
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

                      child: Row(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // 📍 ICON

                          Container(

                            padding:
                                EdgeInsets.all(
                              15,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Colors.orange
                                      .withOpacity(
                                0.15,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),

                            child: Icon(

                              Icons.map,

                              color:
                                  Colors.orange,

                              size: 35,
                            ),
                          ),

                          SizedBox(width: 15),

                          // 📄 INFOS

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  z['nom'],

                                  style: TextStyle(

                                    fontSize: 20,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Text(

                                  z['description'],

                                  style: TextStyle(

                                    color:
                                        Colors.grey[700],

                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(height: 20),

                                // 🔥 ACTIONS

                                Row(

                                  children: [

                                    Expanded(

                                      child:
                                          ElevatedButton.icon(

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

                                        onPressed: () {

                                          TextEditingController
                                              nom =

                                              TextEditingController(

                                            text:
                                                z['nom'],
                                          );

                                          TextEditingController
                                              desc =

                                              TextEditingController(

                                            text:
                                                z['description'],
                                          );

                                          showDialog(

                                            context: context,

                                            builder: (context) {

                                              return AlertDialog(

                                                shape:
                                                    RoundedRectangleBorder(

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    25,
                                                  ),
                                                ),

                                                title: Text(
                                                  "Modifier zone",
                                                ),

                                                content: Column(

                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [

                                                    TextField(

                                                      controller:
                                                          nom,

                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Nom",
                                                      ),
                                                    ),

                                                    SizedBox(height: 10),

                                                    TextField(

                                                      controller:
                                                          desc,

                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Description",
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                actions: [

                                                  TextButton(

                                                    onPressed: () {

                                                      Navigator.pop(
                                                        context,
                                                      );
                                                    },

                                                    child: Text(
                                                      "Annuler",
                                                    ),
                                                  ),

                                                  ElevatedButton(

                                                    style:
                                                        ElevatedButton.styleFrom(

                                                      backgroundColor:
                                                          Color(
                                                        0xFF3E6F55,
                                                      ),
                                                    ),

                                                    onPressed: () async {

                                                      await ApiService
                                                          .updateZone(

                                                        z['id'],

                                                        nom.text,

                                                        desc.text,
                                                      );

                                                      Navigator.pop(
                                                        context,
                                                      );

                                                      setState(() {});
                                                    },

                                                    child: Text(
                                                      "Sauver",
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(width: 10),

                                    Expanded(

                                      child:
                                          ElevatedButton.icon(

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
                                                  "Voulez-vous supprimer cette zone ?",
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

                                            await ApiService
                                                .deleteZone(
                                              z['id'],
                                            );

                                            setState(() {});
                                          }
                                        },
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

      // ➕ ADD BUTTON

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            Color(0xFF3E6F55),

        icon: Icon(Icons.add),

        label: Text(
          "Ajouter",
        ),

        onPressed: () {

          TextEditingController nom =
              TextEditingController();

          TextEditingController desc =
              TextEditingController();

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),
                ),

                title: Text(
                  "Ajouter zone",
                ),

                content: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    TextField(

                      controller: nom,

                      decoration:
                          InputDecoration(
                        labelText: "Nom",
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(

                      controller: desc,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Description",
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },

                    child: Text(
                      "Annuler",
                    ),
                  ),

                  ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Color(0xFF3E6F55),
                    ),

                    onPressed: () async {

                      await ApiService.addZone(

                        nom.text,

                        desc.text,
                      );

                      await ApiService.addLog(

                        "Zone ajoutée",
                      );

                      Navigator.pop(
                        context,
                      );

                      setState(() {});
                    },

                    child: Text(
                      "Ajouter",
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}