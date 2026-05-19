import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MesFavorisScreen extends StatefulWidget {
  @override
  State<MesFavorisScreen> createState() =>
      _MesFavorisScreenState();
}

class _MesFavorisScreenState
    extends State<MesFavorisScreen> {

  List favoris = [];

  @override
  void initState() {
    super.initState();
    loadFavoris();
  }
   Future loadFavoris() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8000/api/mes-favoris/$userId/",
      ),
    );

    setState(() {
      favoris = jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Favoris ❤️"),
        backgroundColor: Color(0xFF3E6F55),
      ),
    body: favoris.isEmpty
          ? Center(
              child: Text(
                "Aucun favori ❤️",
              ),
            )
          : ListView.builder(
              itemCount: favoris.length,
              itemBuilder: (context, index) {

                final fav = favoris[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(fav['titre']),
                    subtitle: Text(fav['description']),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
                );
  }
}