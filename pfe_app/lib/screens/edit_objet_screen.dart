import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/objet.dart';

class EditObjetScreen extends StatefulWidget {
  final Objet objet;

  EditObjetScreen({required this.objet});

  @override
  _EditObjetScreenState createState() =>
      _EditObjetScreenState();
}

class _EditObjetScreenState
    extends State<EditObjetScreen> {

  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController lieuController;
  late TextEditingController telephoneController;

  String selectedStatut = "trouvé";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titreController =
        TextEditingController(
      text: widget.objet.titre,
    );

    descriptionController =
        TextEditingController(
      text: widget.objet.description,
    );

    lieuController =
        TextEditingController(
      text: widget.objet.lieu,
    );

    telephoneController =
        TextEditingController(
      text: widget.objet.telephone ?? "",
    );

    selectedStatut =
        widget.objet.statut;
  }

  // 🔥 UPDATE OBJET

  Future<void> updateObjet() async {

    setState(() {
      isLoading = true;
    });

    var request =
        http.MultipartRequest(

      "PATCH",

      Uri.parse(
        "http://192.168.80.68:8000/api/objets/${widget.objet.id}/",
      ),
    );

    request.fields['titre'] =
        titreController.text;

    request.fields['description'] =
        descriptionController.text;

    request.fields['lieu'] =
        lieuController.text;

    request.fields['telephone'] =
        telephoneController.text;

    request.fields['categorie'] =
        widget.objet.categorie;

    request.fields['statut'] =
        selectedStatut;

    request.fields['user'] =
        widget.objet.user.toString();

    var response =
        await request.send();

    var body =
        await response.stream.bytesToString();

    print(
      "STATUS: ${response.statusCode}",
    );

    print("BODY: $body");

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.green,

          content: Text(
            "Objet modifié avec succès ✅",
          ),
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
              Colors.red,

          content: Text(
            "Erreur de modification ❌",
          ),
        ),
      );
    }
  }

  // 🔥 INPUT DESIGN

  Widget buildInput({

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    int maxLines = 1,
  }) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      style: TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.white70,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),

        filled: true,

        fillColor:
            Colors.white.withOpacity(
          0.12,
        ),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFF18392B),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        backgroundColor:
            Color(0xFF18392B),

        title: Text(

          "Modifier Objet",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              EdgeInsets.all(20),

          child: Container(

            padding:
                EdgeInsets.all(20),

            decoration:
                BoxDecoration(

              color:
                  Colors.white
                      .withOpacity(
                0.08,
              ),

              borderRadius:
                  BorderRadius.circular(
                25,
              ),
            ),

            child: Column(

              children: [

                // 🔥 ICON

                Container(

                  padding:
                      EdgeInsets.all(
                    18,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        Colors.white24,

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(

                    Icons.edit,

                    color:
                        Colors.white,

                    size: 50,
                  ),
                ),

                SizedBox(height: 20),

                Text(

                  "Modifier votre publication",

                  style: TextStyle(

                    color:
                        Colors.white,

                    fontSize: 24,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(

                  "Mettez à jour les informations de l'objet",

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(

                    color:
                        Colors.white70,

                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 30),

                // 🔥 TITRE

                buildInput(

                  controller:
                      titreController,

                  hint:
                      "Titre",

                  icon:
                      Icons.title,
                ),

                SizedBox(height: 18),

                // 🔥 DESCRIPTION

                buildInput(

                  controller:
                      descriptionController,

                  hint:
                      "Description",

                  icon:
                      Icons.description,

                  maxLines: 4,
                ),

                SizedBox(height: 18),

                // 🔥 LIEU

                buildInput(

                  controller:
                      lieuController,

                  hint:
                      "Lieu",

                  icon:
                      Icons.location_on,
                ),

                SizedBox(height: 18),

                // 🔥 TELEPHONE

                buildInput(

                  controller:
                      telephoneController,

                  hint:
                      "Téléphone",

                  icon:
                      Icons.phone,
                ),

                SizedBox(height: 25),

                // 🔥 STATUT

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    ChoiceChip(

                      label: Text(
                        "Trouvé",
                      ),

                      selected:
                          selectedStatut ==
                              "trouvé",

                      selectedColor:
                          Colors.green,

                      backgroundColor:
                          Colors.white24,

                      labelStyle:
                          TextStyle(

                        color:
                            Colors.white,
                      ),

                      onSelected: (_) {

                        setState(() {

                          selectedStatut =
                              "trouvé";
                        });
                      },
                    ),

                    SizedBox(width: 15),

                    ChoiceChip(

                      label: Text(
                        "Perdu",
                      ),

                      selected:
                          selectedStatut ==
                              "perdu",

                      selectedColor:
                          Colors.red,

                      backgroundColor:
                          Colors.white24,

                      labelStyle:
                          TextStyle(

                        color:
                            Colors.white,
                      ),

                      onSelected: (_) {

                        setState(() {

                          selectedStatut =
                              "perdu";
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 35),

                // 🔥 BUTTON

                SizedBox(

                  width:
                      double.infinity,

                  height: 58,

                  child:
                      ElevatedButton(

                    onPressed:

                        isLoading

                            ? null

                            : updateObjet,

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.white,

                      foregroundColor:
                          Color(
                        0xFF18392B,
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    child:

                        isLoading

                            ? CircularProgressIndicator()

                            : Text(

                                "Modifier",

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
        ),
      ),
    );
  }
}