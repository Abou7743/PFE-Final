import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CentreManagementScreen
    extends StatefulWidget {

  @override
  _CentreManagementScreenState
      createState() =>

          _CentreManagementScreenState();
}

class _CentreManagementScreenState
    extends State<CentreManagementScreen> {

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

                      "Centres 🏢",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Gestion des centres",

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

          // 🏢 LISTE CENTRES

          Expanded(

            child:
                FutureBuilder<List<dynamic>>(

              future:
                  ApiService.fetchCentres(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final centres =
                    snapshot.data!;

                if (centres.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.location_city,

                          size: 90,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucun centre 🏢",

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
                      centres.length,

                  itemBuilder:
                      (context, index) {

                    final c =
                        centres[index];

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

                          // 🏢 ICON

                          Container(

                            padding:
                                EdgeInsets.all(
                              15,
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
                                18,
                              ),
                            ),

                            child: Icon(

                              Icons.location_city,

                              color:
                                  Color(0xFF3E6F55),

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

                                  c['nom'],

                                  style: TextStyle(

                                    fontSize: 20,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Row(

                                  children: [

                                    Icon(

                                      Icons.location_on,

                                      size: 18,

                                      color:
                                          Colors.red,
                                    ),

                                    SizedBox(width: 5),

                                    Expanded(

                                      child: Text(

                                        c['adresse'],

                                        style: TextStyle(

                                          color:
                                              Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8),

                                Row(

                                  children: [

                                    Icon(

                                      Icons.phone,

                                      size: 18,

                                      color:
                                          Colors.green,
                                    ),

                                    SizedBox(width: 5),

                                    Text(

                                      c['telephone'],

                                      style: TextStyle(

                                        color:
                                            Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 18),

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
                                                c['nom'],
                                          );

                                          TextEditingController
                                              adresse =

                                              TextEditingController(

                                            text:
                                                c['adresse'],
                                          );

                                          TextEditingController
                                              tel =

                                              TextEditingController(

                                            text:
                                                c['telephone'],
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
                                                  "Modifier centre",
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
                                                          adresse,

                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Adresse",
                                                      ),
                                                    ),

                                                    SizedBox(height: 10),

                                                    TextField(

                                                      controller:
                                                          tel,

                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Téléphone",
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

                                                      await ApiService.updateCentre(

                                                        c['id'],

                                                        nom.text,

                                                        adresse.text,

                                                        tel.text,
                                                      );

                                                      await ApiService.addLog(

                                                        "Centre modifié",
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
                                                  "Voulez-vous supprimer ce centre ?",
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

                                            await ApiService.deleteCentre(

                                              c['id'],
                                            );

                                            await ApiService.addLog(

                                              "Centre supprimé",
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

          TextEditingController adresse =
              TextEditingController();

          TextEditingController tel =
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
                  "Ajouter centre",
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

                      controller: adresse,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Adresse",
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(

                      controller: tel,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Téléphone",
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

                      await ApiService.addCentre(

                        nom.text,

                        adresse.text,

                        tel.text,
                      );

                      await ApiService.addLog(

                        "Centre ajouté",
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