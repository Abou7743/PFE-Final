import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddObjetScreen extends StatefulWidget {

  @override
  _AddObjetScreenState createState() =>
      _AddObjetScreenState();
}

class _AddObjetScreenState
    extends State<AddObjetScreen> {

  // =========================
  // CATEGORIE
  // =========================

  String selectedCategory = "Sac";

  // =========================
  // STATUT
  // =========================

  String selectedStatut = "trouvé";

  // =========================
  // CONTROLLERS
  // =========================

  final titreController =
      TextEditingController();

  final lieuController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final telephoneController =
      TextEditingController();

  // 🔥 AUTRE OBJET
  final autreController =
      TextEditingController();

  // =========================
  // LOCALISATION
  // =========================

  Future getLocation() async {

    Position position =
        await Geolocator
            .getCurrentPosition();

    setState(() {

      lieuController.text =
          "📍 ${position.latitude}, ${position.longitude}";
    });
  }

  // =========================
  // PUBLIER OBJET
  // =========================

  Future submit() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "1";

    var uri = Uri.parse(
      "http://127.0.0.1:8000/api/objets/",
    );

    var request =
        http.MultipartRequest(
      "POST",
      uri,
    );

    // =========================
    // TITRE
    // =========================

    if (selectedCategory == "Autre") {

      request.fields['titre'] =
          autreController.text;

    } else {

      request.fields['titre'] =
          titreController.text;
    }

    // =========================
    // LIEU
    // =========================

    request.fields['lieu'] =
        lieuController.text;

    // =========================
    // DESCRIPTION
    // =========================

    request.fields['description'] =
        descriptionController.text;

    // =========================
    // CATEGORIE
    // =========================

    if (selectedCategory == "Téléphone") {

      request.fields['categorie'] =
          "telephone";

    }

    else if (selectedCategory == "Sac") {

      request.fields['categorie'] =
          "sac";

    }

    else if (selectedCategory == "Clé") {

      request.fields['categorie'] =
          "cle";

    }

    else if (selectedCategory ==
        "Portefeuille") {

      request.fields['categorie'] =
          "portefeuille";

    }

    else if (selectedCategory ==
        "Montre") {

      request.fields['categorie'] =
          "montre";

    }

    else {

      request.fields['categorie'] =
          "autre";
    }

    // =========================
    // STATUT
    // =========================

    request.fields['statut'] =
        selectedStatut;

    // =========================
    // DATE
    // =========================

    request.fields['date_objet'] =
        DateTime.now()
            .toString()
            .split(' ')[0];

    // =========================
    // TELEPHONE
    // =========================

    request.fields['telephone'] =
        telephoneController
                .text
                .isNotEmpty
            ? telephoneController.text
            : "0000000000";

    // =========================
    // USER
    // =========================

    request.fields['user'] =
        userId;

    var response =
        await request.send();

    // =========================
    // SUCCES
    // =========================

    if (response.statusCode == 201) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Objet ajouté avec succès 🔥",
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
            "Erreur ❌ ${response.statusCode}",
          ),
        ),
      );
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF5F5F5),

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.all(20),

          child: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // =========================
                // HEADER
                // =========================

                Row(

                  children: [

                    IconButton(

                      icon: Icon(
                        Icons.arrow_back,
                      ),

                      onPressed: () =>
                          Navigator.pop(
                        context,
                      ),
                    ),

                    SizedBox(width: 10),

                    Text(

                      "Publier un objet",

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 25),

                // =========================
                // TITRE
                // =========================

                if (selectedCategory !=
                    "Autre")

                  Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        "TITRE",

                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      TextField(

                        controller:
                            titreController,

                        decoration:
                            InputDecoration(

                          hintText:
                              "Sac trouvé",

                          filled: true,

                          fillColor:
                              Colors.white,

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 20),

                // =========================
                // CATEGORIE
                // =========================

                Text(

                  "CATÉGORIE",

                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Wrap(

                  spacing: 10,

                  runSpacing: 10,

                  children: [

                    categoryChip(
                        "Téléphone"),

                    categoryChip(
                        "Sac"),

                    categoryChip(
                        "Clé"),

                    categoryChip(
                        "Portefeuille"),

                    categoryChip(
                        "Montre"),

                    categoryChip(
                        "Autre"),
                  ],
                ),

                // =========================
                // AUTRE OBJET
                // =========================

                if (selectedCategory ==
                    "Autre")

                  Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      SizedBox(height: 20),

                      Text(

                        "PRÉCISEZ L'OBJET",

                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      TextField(

                        controller:
                            autreController,

                        decoration:
                            InputDecoration(

                          hintText:
                              "Ex: Lunettes",

                          filled: true,

                          fillColor:
                              Colors.white,

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 20),

                // =========================
                // LIEU
                // =========================

                Text(

                  "LIEU",

                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Row(

                  children: [

                    Expanded(

                      child: TextField(

                        controller:
                            lieuController,

                        decoration:
                            InputDecoration(

                          hintText:
                              "📍 Nouakchott",

                          filled: true,

                          fillColor:
                              Colors.white,

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    CircleAvatar(

                      backgroundColor:
                          Color(0xFF3E6F55),

                      child: IconButton(

                        icon: Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),

                        onPressed:
                            getLocation,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20),

                // =========================
                // DESCRIPTION
                // =========================

                Text(

                  "DESCRIPTION",

                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                TextField(

                  controller:
                      descriptionController,

                  maxLines: 4,

                  decoration:
                      InputDecoration(

                    hintText:
                        "Décrire l'objet...",

                    filled: true,

                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // =========================
                // TELEPHONE
                // =========================

                Text(

                  "TÉLÉPHONE",

                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                TextField(

                  controller:
                      telephoneController,

                  keyboardType:
                      TextInputType.phone,

                  decoration:
                      InputDecoration(

                    hintText:
                        "22200000000",

                    filled: true,

                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // =========================
                // STATUT
                // =========================

                Text(

                  "STATUT",

                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Row(

                  children: [

                    ChoiceChip(

                      label: Text(
                        "Trouvé",
                      ),

                      selected:
                          selectedStatut ==
                              "trouvé",

                      onSelected: (_) {

                        setState(() {

                          selectedStatut =
                              "trouvé";
                        });
                      },
                    ),

                    SizedBox(width: 10),

                    ChoiceChip(

                      label: Text(
                        "Perdu",
                      ),

                      selected:
                          selectedStatut ==
                              "perdu",

                      onSelected: (_) {

                        setState(() {

                          selectedStatut =
                              "perdu";
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // =========================
                // PUBLIER
                // =========================

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: submit,

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
                            BorderRadius.circular(
                          15,
                        ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // CATEGORY CHIP
  // =========================

  Widget categoryChip(
    String text,
  ) {

    bool isSelected =
        selectedCategory == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedCategory = text;
        });
      },

      child: Container(

        padding:
            EdgeInsets.symmetric(

          horizontal: 15,

          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? Color(0xFF3E6F55)
              : Colors.grey[200],

          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        child: Text(

          text,

          style: TextStyle(

            fontWeight:
                FontWeight.bold,

            color: isSelected
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}