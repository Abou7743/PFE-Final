import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/objet.dart';

class ApiService {

  // 🔗 URL BASE (WEB OK)
  static const String baseUrl = "http://192.168.80.68:8000/api";

  // 🔐 HEADERS AVEC TOKEN (SEULEMENT SI EXISTE)
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      return {
        "Authorization": "Token $token",
        "Content-Type": "application/json",
      };
    } else {
      return {
        "Content-Type": "application/json",
      };
    }
  }

  // =========================
  // 📦 OBJETS (PUBLIC 🔥)
  // =========================

  static Future<List<Objet>> fetchObjets() async {

  final objetsResponse = await http.get(
    Uri.parse("$baseUrl/objets/"),
  );

  final documentsResponse = await http.get(
    Uri.parse("$baseUrl/documents/"),
  );

  List objetsData = [];

  List documentsData = [];

  // =========================
  // OBJETS
  // =========================

  if (objetsResponse.statusCode == 200) {

    objetsData =
        jsonDecode(objetsResponse.body);
  }

  // =========================
  // DOCUMENTS
  // =========================

  if (documentsResponse.statusCode == 200) {

    documentsData =
        jsonDecode(documentsResponse.body);

    // 🔥 transformer documents en objets
    for (var doc in documentsData) {

      objetsData.add({

        "id": doc['id'],

        "titre":
            doc['type_document'],

        "description":
            "${doc['nom']} ${doc['prenom']}",

        "statut": "trouvé",

        "date_objet":
            doc['date_naissance'],

        "lieu":
            doc['lieu_trouve'],

        "telephone":
            doc['telephone'],

        "categorie":
            "document",

        "image_url":
            doc['image_url'],

        "image":
            doc['image_url'],

        "user":
            doc['user'],
      });
    }
  }

  return objetsData
      .map((e) => Objet.fromJson(e))
      .toList();
}

  static Future deleteObjet(int id) async {
    final headers = await getHeaders();

    await http.delete(
      Uri.parse("$baseUrl/objets/$id/"),
      headers: headers,
    );
  }

  // =========================
  // 📄 DOCUMENTS
  // =========================

  static Future<List<dynamic>> fetchDocuments() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/documents/"),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  // =========================
  // 👤 USERS (ADMIN)
  // =========================

  static Future<List<dynamic>> fetchUsers() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/users/"),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  static Future deleteUser(int id) async {
    final headers = await getHeaders();

    await http.delete(
      Uri.parse("$baseUrl/users/$id/"),
      headers: headers,
    );
  }

  static Future updateUser(
    int id,
    String nom,
    String email,
    String telephone,
  ) async {
    final headers = await getHeaders();

    await http.patch(
      Uri.parse("$baseUrl/users/$id/"),
      headers: headers,
      body: jsonEncode({
        'nom': nom,
        'email': email,
        'telephone': telephone,
      }),
    );
  }

  // =========================
  // 🏢 CENTRES (ADMIN)
  // =========================

  static Future<List<dynamic>> fetchCentres() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/centres/"),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  static Future addCentre(
    String nom,
    String adresse,
    String telephone,
  ) async {
    final headers = await getHeaders();

    await http.post(
      Uri.parse("$baseUrl/centres/"),
      headers: headers,
      body: jsonEncode({
        'nom': nom,
        'adresse': adresse,
        'telephone': telephone,
      }),
    );
  }

  static Future deleteCentre(int id) async {
    final headers = await getHeaders();

    await http.delete(
      Uri.parse("$baseUrl/centres/$id/"),
      headers: headers,
    );
  }

  static Future updateCentre(
    int id,
    String nom,
    String adresse,
    String telephone,
  ) async {
    final headers = await getHeaders();

    await http.patch(
      Uri.parse("$baseUrl/centres/$id/"),
      headers: headers,
      body: jsonEncode({
        'nom': nom,
        'adresse': adresse,
        'telephone': telephone,
      }),
    );
  }

  // =========================
  // 🌍 ZONES (ADMIN)
  // =========================

  static Future<List<dynamic>> fetchZones() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/zones/"),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  static Future addZone(
    String nom,
    String description,
  ) async {
    final headers = await getHeaders();

    await http.post(
      Uri.parse("$baseUrl/zones/"),
      headers: headers,
      body: jsonEncode({
        'nom': nom,
        'description': description,
      }),
    );
  }

  static Future updateZone(
    int id,
    String nom,
    String description,
  ) async {
    final headers = await getHeaders();

    await http.patch(
      Uri.parse("$baseUrl/zones/$id/"),
      headers: headers,
      body: jsonEncode({
        'nom': nom,
        'description': description,
      }),
    );
  }

  static Future deleteZone(int id) async {
    final headers = await getHeaders();

    await http.delete(
      Uri.parse("$baseUrl/zones/$id/"),
      headers: headers,
    );
  }

  // =========================
  // 🧾 LOGS (ADMIN)
  // =========================

  static Future<List<dynamic>> fetchLogs() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/adminlogs/"),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  static Future addLog(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("id");

    await http.post(
      Uri.parse("$baseUrl/add-log/"),
      body: {
        'user': userId,
        'action': action,
      },
    );
  }

  // =========================
  // 👤 REGISTER
  // =========================

  static Future addUser(
    String nom,
    String email,
    String telephone,
    String password,
  ) async {
    await http.post(
      Uri.parse("$baseUrl/register/"),
      body: {
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'password': password,
      },
    );
  }
}