import 'package:flutter/material.dart';

class AiResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F2A1D),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 HEADER
              Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Analyse IA — Passeport",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 🔹 CARD PRINCIPAL
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E4D34),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),

                        SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("NOM COMPLET",
                                style: TextStyle(color: Colors.white70)),
                            Text("BOUKRI Ahmed",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),

                            SizedBox(height: 5),

                            Text("NUMÉRO",
                                style: TextStyle(color: Colors.white70)),
                            Text("A12345678",
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoBox("NATIONALITÉ", "ALGÉRIENNE"),
                        infoBox("EXPIRATION", "2027-04-12"),
                      ],
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoBox("STATUT OCR", "✓ Extrait"),
                        infoBox("CONFIANCE", "94%"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🎯 SCORE MATCH
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF2E7D55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Correspondance trouvée",
                            style: TextStyle(color: Colors.white)),
                        Text("1 passeport en base",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Text("94%",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 📷 COMPARAISON
              Row(
                children: [

                  Expanded(
                    child: compareCard("Photo trouvée"),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: compareCard("Photo en base", match: true),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 BOX INFO
  Widget infoBox(String title, String value) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // 🔹 CARD COMPARAISON
  Widget compareCard(String text, {bool match = false}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
        border: match
            ? Border.all(color: Colors.greenAccent, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Icon(Icons.person, color: Colors.white),
          SizedBox(height: 10),
          Text(text, style: TextStyle(color: Colors.white)),
          if (match)
            Text("✓ Similaire",
                style: TextStyle(color: Colors.greenAccent)),
        ],
      ),
    );
  }
}