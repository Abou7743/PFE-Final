import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddObjetScreen
    extends StatefulWidget {

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

  final autreController =
      TextEditingController();

  // =========================
  // INIT
  // =========================

  @override
  void initState() {

    super.initState();

    titreController.text =
        "Sac trouvé";
  }

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
  // SUBMIT
  // =========================

  Future submit() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "1";

    var uri = Uri.parse(
      "http://192.168.80.68:8000/api/objets/",
    );

    var request =
        http.MultipartRequest(
      "POST",
      uri,
    );

    // =========================
    // TITRE
    // =========================

    if (selectedCategory ==
        "Autre") {

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

    if (selectedCategory ==
        "Téléphone") {

      request.fields['categorie'] =
          "telephone";

    }

    else if (selectedCategory ==
        "Sac") {

      request.fields['categorie'] =
          "sac";

    }

    else if (selectedCategory ==
        "Clé") {

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

    if (response.statusCode ==
        201) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.green,

          content: Text(
            "Objet publié avec succès ✅",
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
            "Erreur ❌ ${response.statusCode}",
          ),
        ),
      );
    }
  }

  // =========================
  // FIELD
  // =========================

  Widget field({

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    bool readOnly = false,

    int maxLines = 1,

  }) {

    return TextField(

      controller: controller,

      readOnly: readOnly,

      maxLines: maxLines,

      decoration: InputDecoration(

        hintText: hint,

        prefixIcon: Icon(

          icon,

          color:
              Color(0xFF3E6F55),
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

      body: SafeArea(

        child:
            SingleChildScrollView(

          padding:
              EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // =========================
              // HEADER
              // =========================

              Row(

                children: [

                  Container(

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black12,

                          blurRadius: 6,
                        ),
                      ],
                    ),

                    child: IconButton(

                      icon: Icon(
                        Icons.arrow_back,
                      ),

                      onPressed: () {

                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),

                  SizedBox(width: 15),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          "Publier Objet",

                          style: TextStyle(

                            fontSize: 24,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(

                          "Ajoutez un objet trouvé",

                          style: TextStyle(

                            color:
                                Colors.grey,

                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // =========================
              // HEADER CARD
              // =========================

              Container(

                padding:
                    EdgeInsets.all(22),

                decoration:
                    BoxDecoration(

                  gradient:
                      LinearGradient(

                    colors: [

                      Colors.white,

                      Color(
                        0xFFF1F5F2,
                      ),
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

                      blurRadius: 12,

                      offset:
                          Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    Container(

                      padding:
                          EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Color(
                          0xFFE8F1EC,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: Icon(

                        Icons.inventory_2,

                        size: 65,

                        color:
                            Color(
                          0xFF3E6F55,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(

                      "Publication rapide",

                      style: TextStyle(

                        fontSize: 19,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Choisissez la catégorie puis remplissez les informations",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color:
                            Colors.grey,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // =========================
              // TITRE
              // =========================

              if (selectedCategory !=
                  "Autre")

                Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    sectionTitle(
                      "TITRE",
                    ),

                    SizedBox(height: 10),

                    field(

                      controller:
                          titreController,

                      hint:
                          "Sac trouvé",

                      icon:
                          Icons.title,

                      readOnly: true,
                    ),
                  ],
                ),

              SizedBox(height: 25),

              // =========================
              // CATEGORIE
              // =========================

              sectionTitle(
                "CATÉGORIE",
              ),

              SizedBox(height: 12),

              Wrap(

                spacing: 10,

                runSpacing: 12,

                children: [

                  categoryChip(
                    "Téléphone",
                    Icons.phone_android,
                  ),

                  categoryChip(
                    "Sac",
                    Icons.work,
                  ),

                  categoryChip(
                    "Clé",
                    Icons.key,
                  ),

                  categoryChip(
                    "Portefeuille",
                    Icons.wallet,
                  ),

                  categoryChip(
                    "Montre",
                    Icons.watch,
                  ),

                  categoryChip(
                    "Autre",
                    Icons.inventory_2,
                  ),
                ],
              ),

              // =========================
              // AUTRE OBJET
              // =========================

              if (selectedCategory ==
                  "Autre")

                Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    SizedBox(height: 25),

                    sectionTitle(
                      "PRÉCISEZ L'OBJET",
                    ),

                    SizedBox(height: 10),

                    field(

                      controller:
                          autreController,

                      hint:
                          "Ex: Lunettes",

                      icon:
                          Icons.edit,
                    ),
                  ],
                ),

              SizedBox(height: 25),

              // =========================
              // LIEU
              // =========================

              sectionTitle(
                "LIEU",
              ),

              SizedBox(height: 10),

              Row(

                children: [

                  Expanded(

                    child: field(

                      controller:
                          lieuController,

                      hint:
                          "📍 Nouakchott",

                      icon:
                          Icons.location_on,
                    ),
                  ),

                  SizedBox(width: 12),

                  Container(

                    decoration:
                        BoxDecoration(

                      color:
                          Color(
                        0xFF3E6F55,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: IconButton(

                      icon: Icon(

                        Icons.my_location,

                        color:
                            Colors.white,
                      ),

                      onPressed:
                          getLocation,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              // =========================
              // DESCRIPTION
              // =========================

              sectionTitle(
                "DESCRIPTION",
              ),

              SizedBox(height: 10),

              field(

                controller:
                    descriptionController,

                hint:
                    "Décrire l'objet...",

                icon:
                    Icons.description,

                maxLines: 4,
              ),

              SizedBox(height: 25),

              // =========================
              // TELEPHONE
              // =========================

              sectionTitle(
                "TÉLÉPHONE",
              ),

              SizedBox(height: 10),

              field(

                controller:
                    telephoneController,

                hint:
                    "22200000000",

                icon:
                    Icons.phone,
              ),

              SizedBox(height: 25),

              // =========================
              // STATUT
              // =========================

              sectionTitle(
                "STATUT",
              ),

              SizedBox(height: 12),

              Row(

                children: [

                  statutChip(
                    "trouvé",
                    "Trouvé",
                    Colors.green,
                  ),

                  SizedBox(width: 12),

                  statutChip(
                    "perdu",
                    "Perdu",
                    Colors.red,
                  ),
                ],
              ),

              SizedBox(height: 35),

              // =========================
              // BUTTON
              // =========================

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: submit,

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

                        color:
                            Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(

                        "Publier Objet",

                        style: TextStyle(

                          fontSize: 18,

                          color:
                              Colors.white,

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
      ),
    );
  }

  // =========================
  // SECTION TITLE
  // =========================

  Widget sectionTitle(
      String text) {

    return Text(

      text,

      style: TextStyle(

        color: Colors.grey,

        fontWeight:
            FontWeight.bold,

        fontSize: 13,
      ),
    );
  }

  // =========================
  // CATEGORY CHIP
  // =========================

  Widget categoryChip(

    String text,

    IconData icon,

  ) {

    bool isSelected =
        selectedCategory == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedCategory = text;

          if (text != "Autre") {

            titreController.text =
                "$text trouvé";
          }

          else {

            titreController.clear();
          }
        });
      },

      child: Container(

        padding:
            EdgeInsets.symmetric(

          horizontal: 16,

          vertical: 12,
        ),

        decoration:
            BoxDecoration(

          color: isSelected

              ? Color(
                  0xFF3E6F55,
                )

              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black12,

              blurRadius: 6,
            ),
          ],
        ),

        child: Row(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            Icon(

              icon,

              size: 18,

              color: isSelected

                  ? Colors.white

                  : Color(
                      0xFF3E6F55,
                    ),
            ),

            SizedBox(width: 8),

            Text(

              text,

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                color: isSelected

                    ? Colors.white

                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // STATUT CHIP
  // =========================

  Widget statutChip(

    String value,

    String text,

    Color color,

  ) {

    bool isSelected =
        selectedStatut == value;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedStatut = value;
        });
      },

      child: Container(

        padding:
            EdgeInsets.symmetric(

          horizontal: 18,

          vertical: 12,
        ),

        decoration:
            BoxDecoration(

          color: isSelected

              ? color

              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black12,

              blurRadius: 5,
            ),
          ],
        ),

        child: Row(

          children: [

            Icon(

              value == "trouvé"

                  ? Icons.check_circle

                  : Icons.error,

              color: isSelected

                  ? Colors.white

                  : color,
            ),

            SizedBox(width: 8),

            Text(

              text,

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                color: isSelected

                    ? Colors.white

                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}