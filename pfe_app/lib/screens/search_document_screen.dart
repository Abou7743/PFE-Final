import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;

class SearchDocumentScreen
    extends StatefulWidget {

  @override
  State<SearchDocumentScreen>
      createState() =>
          _SearchDocumentScreenState();
}

class _SearchDocumentScreenState
    extends State<SearchDocumentScreen> {

  // =========================
  // CONTROLLERS
  // =========================

  TextEditingController nomController =
      TextEditingController();

  TextEditingController prenomController =
      TextEditingController();

  TextEditingController nniController =
      TextEditingController();

  TextEditingController dateController =
      TextEditingController();

  // =========================
  // VARIABLES
  // =========================

  List results = [];

  bool loading = false;

  // =========================
  // SEARCH
  // =========================

  Future search() async {

    setState(() {

      loading = true;
    });

    final response = await http.post(

      Uri.parse(
        "http://192.168.80.68:8000/api/search-document/",
      ),

      body: {

        "nom":
            nomController.text,

        "prenom":
            prenomController.text,

        "nni":
            nniController.text,

        "date_naissance":
            dateController.text,
      },
    );

    setState(() {

      results =
          jsonDecode(response.body);

      loading = false;
    });
  }

  // =========================
  // FIELD
  // =========================

  Widget field(

    TextEditingController controller,

    String hint,

    IconData icon,

  ) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: Icon(

            icon,

            color:
                Color(0xFF3E6F55),
          ),

          filled: true,

          fillColor:
              Color(0xFFFAFAFA),

          contentPadding:
              EdgeInsets.symmetric(
            vertical: 18,
          ),

          enabledBorder:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide: BorderSide(

              color:
                  Colors.grey.shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide: BorderSide(

              color:
                  Color(0xFF3E6F55),

              width: 2,
            ),
          ),
        ),
      ),
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

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            Color(0xFF3E6F55),

        title: Column(

          children: [

            Text(

              "Recherche Document",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 20,
              ),
            ),

            SizedBox(height: 2),

            Text(

              "Retrouvez vos documents",

              style: TextStyle(

                fontSize: 11,

                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: EdgeInsets.all(18),

          child: Column(

            children: [

              // =========================
              // HEADER CARD
              // =========================

              Container(

                padding:
                    EdgeInsets.all(20),

                decoration: BoxDecoration(

                  gradient: LinearGradient(

                    colors: [

                      Colors.white,

                      Color(0xFFF1F5F2),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.black12,

                      blurRadius: 12,

                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    Container(

                      padding:
                          EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Color(0xFFE8F1EC),

                        shape:
                            BoxShape.circle,
                      ),

                      child: Icon(

                        Icons.search,

                        size: 55,

                        color:
                            Color(0xFF3E6F55),
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(

                      "Recherche intelligente",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Entrez les informations du document",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color: Colors.grey,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // =========================
              // FIELDS
              // =========================

              field(
                nomController,
                "Nom",
                Icons.person,
              ),

              field(
                prenomController,
                "Prénom",
                Icons.person_outline,
              ),

              field(
                nniController,
                "NNI",
                Icons.credit_card,
              ),

              field(
                dateController,
                "Date naissance",
                Icons.calendar_month,
              ),

              SizedBox(height: 10),

              // =========================
              // BUTTON
              // =========================

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: search,

                  style:
                      ElevatedButton.styleFrom(

                    elevation: 8,

                    shadowColor:
                        Colors.black38,

                    backgroundColor:
                        Color(0xFF3E6F55),

                    padding:
                        EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Icon(

                        Icons.search,

                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(

                        "Rechercher",

                        style: TextStyle(

                          fontSize: 17,

                          color: Colors.white,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // =========================
              // LOADING
              // =========================

              if (loading)

                Padding(

                  padding:
                      EdgeInsets.only(
                    top: 20,
                  ),

                  child:
                      CircularProgressIndicator(
                    color:
                        Color(0xFF3E6F55),
                  ),
                ),

              SizedBox(height: 20),

              // =========================
              // RESULTS
              // =========================

              if (results.isEmpty)

                Column(

                  children: [

                    Icon(

                      Icons.description_outlined,

                      size: 70,

                      color:
                          Colors.grey[400],
                    ),

                    SizedBox(height: 10),

                    Text(

                      "Aucun document",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                )

              else

                ListView.builder(

                  shrinkWrap: true,

                  physics:
                      NeverScrollableScrollPhysics(),

                  itemCount:
                      results.length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                        results[index];

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
                          22,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.black12,

                            blurRadius: 10,

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

                          // =========================
                          // IMAGE
                          // =========================

                          if (doc['image_url']
                              != null)

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.vertical(

                                top:
                                    Radius.circular(
                                  22,
                                ),
                              ),

                              child:
                                  Image.network(

                                doc['image_url'],

                                height: 210,

                                width:
                                    double.infinity,

                                fit: BoxFit.cover,
                              ),
                            ),

                          // =========================
                          // CONTENT
                          // =========================

                          Padding(

                            padding:
                                EdgeInsets.all(
                              18,
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Row(

                                  children: [

                                    CircleAvatar(

                                      backgroundColor:
                                          Color(
                                        0xFFE8F1EC,
                                      ),

                                      child: Text(

                                        doc['nom'][0],

                                        style: TextStyle(

                                          color:
                                              Color(
                                            0xFF3E6F55,
                                          ),

                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    Expanded(

                                      child: Text(

                                        "${doc['nom']} ${doc['prenom']}",

                                        style: TextStyle(

                                          fontWeight:
                                              FontWeight.bold,

                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 18),

                                infoTile(
                                  Icons.badge,
                                  doc['type_document'],
                                ),

                                infoTile(
                                  Icons.credit_card,
                                  doc['nni'],
                                ),

                                infoTile(
                                  Icons.location_on,
                                  doc['lieu_trouve'],
                                ),

                                infoTile(
                                  Icons.phone,
                                  doc['telephone'],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // INFO TILE
  // =========================

  Widget infoTile(

    IconData icon,

    String text,

  ) {

    return Padding(

      padding:
          EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(

        children: [

          Container(

            padding:
                EdgeInsets.all(8),

            decoration:
                BoxDecoration(

              color:
                  Color(0xFFE8F1EC),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(

              icon,

              color:
                  Color(0xFF3E6F55),

              size: 18,
            ),
          ),

          SizedBox(width: 12),

          Expanded(

            child: Text(

              text,

              style: TextStyle(

                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}