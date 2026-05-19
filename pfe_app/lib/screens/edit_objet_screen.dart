import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/objet.dart';

class EditObjetScreen extends StatefulWidget {
  final Objet objet;

  EditObjetScreen({required this.objet});

  @override
  _EditObjetScreenState createState() => _EditObjetScreenState();
}

class _EditObjetScreenState extends State<EditObjetScreen> {

  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController lieuController;
  late TextEditingController telephoneController;

  String selectedStatut = "trouvé";

  @override
  void initState() {
    super.initState();

    titreController =
        TextEditingController(text: widget.objet.titre);

    descriptionController =
        TextEditingController(text: widget.objet.description);

    lieuController =
        TextEditingController(text: widget.objet.lieu);

    telephoneController =
        TextEditingController(text: widget.objet.telephone ?? "");

    selectedStatut = widget.objet.statut;
  }

  // 🔥 SEULE MODIFICATION ICI
  Future<void> updateObjet() async {

    var request = http.MultipartRequest(
      "PATCH",
      Uri.parse("http://127.0.0.1:8000/api/objets/${widget.objet.id}/"),
    );

    request.fields['titre'] = titreController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['lieu'] = lieuController.text;
    request.fields['telephone'] = telephoneController.text;
    request.fields['categorie'] = widget.objet.categorie;
    request.fields['statut'] = selectedStatut;
    request.fields['user'] = widget.objet.user.toString();

    var response = await request.send();
    var body = await response.stream.bytesToString();

    print("STATUS: ${response.statusCode}");
    print("BODY: $body");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Objet modifié ✅")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier objet")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: "Titre"),
            ),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),

            TextField(
              controller: lieuController,
              decoration: InputDecoration(labelText: "Lieu"),
            ),

            TextField(
              controller: telephoneController,
              decoration: InputDecoration(labelText: "Téléphone"),
            ),

            SizedBox(height:20),

            Row(
              children: [
                ChoiceChip(
                  label: Text("Trouvé"),
                  selected: selectedStatut == "trouvé",
                  onSelected: (_) {
                    setState(() {
                      selectedStatut = "trouvé";
                    });
                  },
                ),
                SizedBox(width:10),
                ChoiceChip(
                  label: Text("Perdu"),
                  selected: selectedStatut == "perdu",
                  onSelected: (_) {
                    setState(() {
                      selectedStatut = "perdu";
                    });
                  },
                ),
              ],
            ),

            SizedBox(height:20),

            ElevatedButton(
              onPressed: updateObjet,
              child: Text("Modifier"),
            )
          ],
        ),
      ),
    );
  }
}