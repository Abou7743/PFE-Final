import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/objet.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Objet> allObjets = [];
  List<Objet> results = [];

  TextEditingController searchController = TextEditingController();

  void search(String query) {
    final filtered = allObjets.where((obj) {
      return obj.titre.toLowerCase().contains(query.toLowerCase()) ||
             obj.lieu.toLowerCase().contains(query.toLowerCase()) ||
             obj.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      results = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: Column(
        children: [

          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(
              color: Color(0xFF3E6F55),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 10),
                Text(
                  "Recherche",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 15),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Rechercher un objet...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: FutureBuilder<List<Objet>>(
              future: ApiService.fetchObjets(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (allObjets.isEmpty) {
                  allObjets = snapshot.data!;
                  results = allObjets;
                }

                if (results.isEmpty) {
                  return Center(
                    child: Text("Aucun résultat 😢"),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {

                    final obj = results[index];

                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [

                          // ✅ CORRECTION IMAGE MANQUANTE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: obj.imageUrl != null &&
                                   obj.imageUrl!.isNotEmpty
                                ? Image.network(
                                    obj.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.green.withOpacity(0.1),
                                    child: Icon(
                                      Icons.description,
                                      color: Colors.green,
                                    ),
                                  ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  obj.titre,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  "📍 ${obj.lieu}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                                Text(
                                  obj.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
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