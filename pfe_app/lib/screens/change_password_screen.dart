import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ AJOUT
import 'package:http/http.dart' as http; // ✅ AJOUT

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

  // 🔥 FONCTION MODIFIÉE (API DJANGO)
  void change() async {
    final prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("id");

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/change-password/"),
      body: {
        'id': userId,
        'old_password': oldPass.text,
        'new_password': newPass.text,
      },
    );

    if (response.statusCode == 200) {

      // 🔥 MAJ LOCAL
      await prefs.setString("password", newPass.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mot de passe changé ✔")),
      );

      Navigator.pop(context, true);
 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur mot de passe ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              // HEADER
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("Sécurité",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),

              SizedBox(height: 20),

              customField(oldPass, "Ancien mot de passe"),
              SizedBox(height: 15),

              customField(newPass, "Nouveau mot de passe"),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: change,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3E6F55),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text("Changer mot de passe"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customField(controller, hint) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}