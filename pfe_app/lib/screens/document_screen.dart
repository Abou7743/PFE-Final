import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../models/objet.dart';

import 'detail_screen.dart';

class DocumentScreen extends StatefulWidget {

  @override
  _DocumentScreenState createState() =>
      _DocumentScreenState();
}

class _DocumentScreenState
    extends State<DocumentScreen> {

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

                      "Documents",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Documents retrouvés 📄",

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

                final allItems =
                    snapshot.data!;

                // ✅ FILTRE DOCUMENTS

                final documents =
                    allItems.where((doc){

                  return doc.categorie
                          .toLowerCase() ==

                      "document";

                }).toList();

                if (documents.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.description,

                          size: 80,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucun document 📄",

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
                      documents.length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                        documents[index];

                    return GestureDetector(

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                DetailScreen(

                              objet: doc,
                            ),
                          ),
                        );
                      },

                      child: AnimatedContainer(

                        duration:
                            Duration(
                          milliseconds: 300,
                        ),

                        margin:
                            EdgeInsets.symmetric(

                          horizontal: 18,

                          vertical: 8,
                        ),

                        padding:
                            EdgeInsets.all(12),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color: Colors.black12,

                              blurRadius: 8,

                              offset:
                                  Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(

                          children: [

                            // 📸 IMAGE

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                15,
                              ),

                              child:

                                  doc.imageUrl != null

                                      ? Image.network(

                                          doc.imageUrl!,

                                          width: 85,

                                          height: 85,

                                          fit: BoxFit.cover,
                                        )

                                      : Container(

                                          width: 85,

                                          height: 85,

                                          color:
                                              Colors.grey[300],

                                          child: Icon(

                                            Icons.description,

                                            size: 40,

                                            color:
                                                Colors.grey,
                                          ),
                                        ),
                            ),

                            SizedBox(width: 15),

                            // 📄 INFOS

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    doc.titre,

                                    style: TextStyle(

                                      fontSize: 17,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Row(

                                    children: [

                                      Icon(

                                        Icons.location_on,

                                        color:
                                            Colors.grey,

                                        size: 18,
                                      ),

                                      SizedBox(width: 5),

                                      Expanded(

                                        child: Text(

                                          doc.lieu,

                                          style: TextStyle(

                                            color:
                                                Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  Container(

                                    padding:
                                        EdgeInsets.symmetric(

                                      horizontal: 12,

                                      vertical: 5,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      color:
                                          Colors.green,

                                      borderRadius:
                                          BorderRadius.circular(
                                        30,
                                      ),
                                    ),

                                    child: Text(

                                      "Trouvé",

                                      style: TextStyle(

                                        color: Colors.white,

                                        fontSize: 12,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ➡️

                            Icon(

                              Icons.arrow_forward_ios,

                              color: Colors.grey,

                              size: 18,
                            )
                          ],
                        ),
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