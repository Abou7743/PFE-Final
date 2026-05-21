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

  TextEditingController telController =
      TextEditingController();

  TextEditingController lieuController =
      TextEditingController();

  // =========================
  // VARIABLES
  // =========================

  String typeDocument =
      "Carte identité";

  XFile? image;

  double latitude = 0;

  double longitude = 0;

  // =========================
  // LOCALISATION
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
  // IMAGE
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
  // PUBLIER
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
    // IMAGE
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

    // =========================
    // SUCCES
    // =========================

    if (response.statusCode == 201) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.green,

          content: Text(
            "Document publié avec succès ✅",
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

          backgroundColor:
              Colors.red,

          content: Text(
            "Erreur publication ❌",
          ),
        ),
      );
    }
  }

  // =========================
  // CHAMP
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
            color: Color(0xFF3E6F55),
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

              "Publier Document",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 20,
              ),
            ),

            SizedBox(height: 2),

            Text(

              "Ajoutez un document trouvé",

              style: TextStyle(

                fontSize: 11,

                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            // =========================
            // IMAGE CARD
            // =========================

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 220,

                width: double.infinity,

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

                      blurRadius: 15,

                      offset: Offset(0, 5),
                    ),
                  ],
                ),

                child: image == null

                    ? Column(

                        mainAxisAlignment:
                            MainAxisAlignment.center,

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

                              Icons.add_a_photo_rounded,

                              size: 70,

                              color:
                                  Color(0xFF3E6F55),
                            ),
                          ),

                          SizedBox(height: 18),

                          Text(

                            "Ajouter photo document",

                            style: TextStyle(

                              fontSize: 17,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(

                            "Carte • Passeport • Permis",

                            style: TextStyle(

                              color:
                                  Colors.grey,

                              fontSize: 13,
                            ),
                          ),
                        ],
                      )

                    : ClipRRect(

                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),

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

            SizedBox(height: 30),

            // =========================
            // TYPE DOCUMENT
            // =========================

            DropdownButtonFormField(

              value: typeDocument,

              decoration: InputDecoration(

                prefixIcon: Icon(

                  Icons.badge,

                  color:
                      Color(0xFF3E6F55),
                ),

                filled: true,

                fillColor:
                    Color(0xFFFAFAFA),

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

            // =========================
            // CHAMPS
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

            field(
              telController,
              "Téléphone",
              Icons.phone,
            ),

            field(
              lieuController,
              "Lieu trouvé",
              Icons.location_on,
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
                      Icons.cloud_upload,
                      color: Colors.white,
                    ),

                    SizedBox(width: 10),

                    Text(

                      "Publier le document",

                      style: TextStyle(

                        fontSize: 18,

                        color: Colors.white,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}