import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';

class AddDocumentScreen extends StatefulWidget {

  @override
  State<AddDocumentScreen> createState() =>
      _AddDocumentScreenState();
}

class _AddDocumentScreenState
    extends State<AddDocumentScreen> {

  TextEditingController nomController =
      TextEditingController();

  TextEditingController prenomController =
      TextEditingController();

  TextEditingController nniController =
      TextEditingController();

  TextEditingController dateController =
      TextEditingController();

  TextEditingController telController =
      TextEditingController();

  TextEditingController lieuController =
      TextEditingController();

  String typeDocument =
      "Carte identité";

  XFile? image;

  double latitude = 0;

  double longitude = 0;

  // =========================
  // 📍 LOCALISATION
  // =========================

  Future getLocation() async {

    await Geolocator.requestPermission();

    Position position =
        await Geolocator
            .getCurrentPosition();

    latitude =
        position.latitude;

    longitude =
        position.longitude;
  }

  // =========================
  // 🖼️ CHOISIR IMAGE
  // =========================

  Future pickImage() async {

    final picked =
        await ImagePicker().pickImage(

      source: ImageSource.gallery,
    );

    if (picked != null) {

      setState(() {

        image = picked;
      });
    }
  }

  // =========================
  // 🚀 PUBLIER DOCUMENT
  // =========================

  Future publishDocument() async {

    await getLocation();

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    var request =
        http.MultipartRequest(

      'POST',

      Uri.parse(
        "http://127.0.0.1:8000/api/documents/",
      ),
    );

    request.fields['user'] =
        userId;

    request.fields['nom'] =
        nomController.text;

    request.fields['prenom'] =
        prenomController.text;

    request.fields['nni'] =
        nniController.text;

    request.fields['date_naissance'] =
        dateController.text;

    request.fields['telephone'] =
        telController.text;

    request.fields['lieu_trouve'] =
        lieuController.text;

    request.fields['type_document'] =
        typeDocument;

    request.fields['latitude'] =
        latitude.toString();

    request.fields['longitude'] =
        longitude.toString();

    // =========================
    // 🖼️ IMAGE
    // =========================

    if (image != null) {

      final bytes =
          await image!.readAsBytes();

      request.files.add(

        http.MultipartFile.fromBytes(

          'image',

          bytes,

          filename: image!.name,

          contentType:
              MediaType(
            'image',
            'jpeg',
          ),
        ),
      );
    }

    var response =
        await request.send();

    print(response.statusCode);

    final body =
        await response.stream
            .bytesToString();

    print(body);

    // =========================
    // ✅ SUCCÈS
    // =========================

    if (response.statusCode == 201) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Document publié ✅",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Erreur publication ❌",
          ),
        ),
      );
    }
  }

  // =========================
  // ✏️ CHAMP
  // =========================

  Widget field(

    TextEditingController controller,

    String hint,

  ) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 12,
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(15),

            borderSide:
                BorderSide.none,
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
          Color(0xFFF5F5F5),

      appBar: AppBar(

        title: Text(
          "Publier Document 🪪",
        ),

        centerTitle: true,

        elevation: 0,

        backgroundColor:
            Color(0xFF3E6F55),
      ),

      body: SingleChildScrollView(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            // =========================
            // IMAGE
            // =========================

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 200,

                width: double.infinity,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.black12,

                      blurRadius: 10,

                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: image == null

                    ? Column(

                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Icon(

                            Icons.camera_alt,

                            size: 60,

                            color:
                                Color(0xFF3E6F55),
                          ),

                          SizedBox(height: 10),

                          Text(

                            "Ajouter photo document",

                            style: TextStyle(

                              fontSize: 16,

                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      )

                    : ClipRRect(

                        borderRadius:
                            BorderRadius.circular(20),

                        child: FutureBuilder(

                          future:
                              image!.readAsBytes(),

                          builder:
                              (context, snapshot) {

                            if (!snapshot.hasData) {

                              return Center(

                                child:
                                    CircularProgressIndicator(),
                              );
                            }

                            return Image.memory(

                              snapshot.data!,

                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
              ),
            ),

            SizedBox(height: 25),

            // =========================
            // TYPE DOCUMENT
            // =========================

            DropdownButtonFormField(

              value: typeDocument,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(15),

                  borderSide:
                      BorderSide.none,
                ),
              ),

              items: [

                "Carte identité",
                "Passeport",
                "Permis",
                "Carte étudiant",
                "Document",

              ].map((e) {

                return DropdownMenuItem(

                  value: e,

                  child: Text(e),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  typeDocument =
                      value!;
                });
              },
            ),

            SizedBox(height: 20),

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

            field(
              telController,
              "Téléphone",
            ),

            field(
              lieuController,
              "Lieu trouvé",
            ),

            SizedBox(height: 25),

            // =========================
            // BOUTON
            // =========================

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed:
                    publishDocument,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Color(0xFF3E6F55),

                  padding:
                      EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                child: Text(

                  "Publier",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}