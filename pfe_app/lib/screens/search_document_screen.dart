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

  TextEditingController nomController =
      TextEditingController();

  TextEditingController prenomController =
      TextEditingController();

  TextEditingController nniController =
      TextEditingController();

  TextEditingController dateController =
      TextEditingController();

  List results = [];

  bool loading = false;

  Future search() async {

    setState(() {
      loading = true;
    });

    final response = await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/search-document/",
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

  Widget field(
      TextEditingController controller,
      String hint) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 12,
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
            Text("Recherche 🔍"),

        backgroundColor:
            Color(0xFF3E6F55),
      ),

      body: Padding(

        padding: EdgeInsets.all(15),

        child: Column(
          children: [

            field(
              nomController,
              "Nom",
            ),

            field(
              prenomController,
              "Prénom",
            ),

            field(
              nniController,
              "NNI",
            ),

            field(
              dateController,
              "Date naissance",
            ),

            SizedBox(height: 15),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: search,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Color(0xFF3E6F55),

                  padding:
                      EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                child: Text(
                  "Rechercher",
                ),
              ),
            ),

            SizedBox(height: 20),

            if (loading)
              CircularProgressIndicator(),

            Expanded(

              child: ListView.builder(

                itemCount:
                    results.length,

                itemBuilder:
                    (context, index) {

                  final doc =
                      results[index];

                  return Card(

                    margin:
                        EdgeInsets.only(
                      bottom: 15,
                    ),

                    child: Padding(

                      padding:
                          EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          if (doc['image_url']
                              != null)

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                      12),

                              child: Image.network(

                                doc['image_url'],

                                height: 180,

                                width:
                                    double.infinity,

                                fit: BoxFit.cover,
                              ),
                            ),

                          SizedBox(height: 10),

                          Text(
                            "${doc['nom']} ${doc['prenom']}",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "🪪 ${doc['type_document']}",
                          ),

                          Text(
                            "🆔 ${doc['nni']}",
                          ),

                          Text(
                            "📍 ${doc['lieu_trouve']}",
                          ),

                          Text(
                            "📞 ${doc['telephone']}",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}