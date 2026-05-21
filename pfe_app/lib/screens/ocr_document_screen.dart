import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_screen.dart';

class OCRDocumentScreen extends StatefulWidget {

  @override
  State<OCRDocumentScreen> createState() =>
      _OCRDocumentScreenState();
}

class _OCRDocumentScreenState
    extends State<OCRDocumentScreen> {

  // =========================
  // VARIABLES
  // =========================

  XFile? image;

  bool loading = false;

  String result = "";

  Map? matchedDocument;

  bool matched = false;

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
  // OCR
  // =========================

  Future scanOCR() async {

    if (image == null) return;

    setState(() {

      loading = true;

      matched = false;

      matchedDocument = null;

      result = "";
    });

    try {

      var request =
          http.MultipartRequest(

        'POST',

        Uri.parse(
          "http://127.0.0.1:8000/api/ocr-document/",
        ),
      );

      request.files.add(

        http.MultipartFile.fromBytes(

          'image',

          await image!.readAsBytes(),

          filename: image!.name,
        ),
      );

      var response =
          await request.send();

      final body =
          await response.stream
              .bytesToString();

      final data =
          jsonDecode(body);

      setState(() {

        result =
            data['matched'] == false
            ? data['message']
            : data['ocr_text'] ?? "";

        matched =
            data['matched'] ?? false;

        matchedDocument =
            data['document'];

        loading = false;
      });

    } catch (e) {

      setState(() {

        loading = false;

        result =
            "Erreur OCR : $e";
      });
    }
  }

  // =========================
  // INFO TILE
  // =========================

  Widget infoTile(

    IconData icon,

    String text,

  ) {

    return Padding(

      padding:
          EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(

        children: [

          Container(

            padding:
                EdgeInsets.all(10),

            decoration:
                BoxDecoration(

              color:
                  Color(0xFFE8F1EC),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(

              icon,

              color:
                  Color(0xFF3E6F55),

              size: 20,
            ),
          ),

          SizedBox(width: 12),

          Expanded(

            child: Text(

              text,

              style: TextStyle(

                fontSize: 15,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
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

              "Scanner IA",

              style: TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 20,
              ),
            ),

            SizedBox(height: 2),

            Text(

              "OCR intelligent document",

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
            // HEADER CARD
            // =========================

            Container(

              padding:
                  EdgeInsets.all(20),

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

                    blurRadius: 12,

                    offset: Offset(0, 4),
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
                          Color(0xFFE8F1EC),

                      shape:
                          BoxShape.circle,
                    ),

                    child: Icon(

                      Icons.document_scanner,

                      size: 65,

                      color:
                          Color(0xFF3E6F55),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(

                    "Scanner intelligent",

                    style: TextStyle(

                      fontSize: 19,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(

                    "Analyse automatique des documents avec IA",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      color: Colors.grey,

                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // =========================
            // IMAGE PICKER
            // =========================

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 240,

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

                      blurRadius: 12,

                      offset: Offset(0, 4),
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

                              Icons.add_photo_alternate,

                              size: 70,

                              color:
                                  Color(0xFF3E6F55),
                            ),
                          ),

                          SizedBox(height: 18),

                          Text(

                            "Choisir une image",

                            style: TextStyle(

                              fontSize: 18,

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

                    : FutureBuilder<Uint8List>(

                        future:
                            image!.readAsBytes(),

                        builder: (
                          context,
                          snapshot,
                        ) {

                          if (!snapshot
                              .hasData) {

                            return Center(

                              child:
                                  CircularProgressIndicator(),
                            );
                          }

                          return ClipRRect(

                            borderRadius:
                                BorderRadius.circular(
                              25,
                            ),

                            child: Image.memory(

                              snapshot.data!,

                              fit: BoxFit.cover,

                              width:
                                  double.infinity,

                              height: 240,
                            ),
                          );
                        },
                      ),
              ),
            ),

            SizedBox(height: 25),

            // =========================
            // BUTTON
            // =========================

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: scanOCR,

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

                      Icons.document_scanner,

                      color: Colors.white,
                    ),

                    SizedBox(width: 10),

                    Text(

                      "Scanner Document",

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

            SizedBox(height: 25),

            // =========================
            // LOADING
            // =========================

            if (loading)

              Column(

                children: [

                  CircularProgressIndicator(

                    color:
                        Color(0xFF3E6F55),
                  ),

                  SizedBox(height: 15),

                  Text(

                    "Analyse IA en cours...",

                    style: TextStyle(

                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ],
              ),

            // =========================
            // OCR RESULT
            // =========================

            if (result.isNotEmpty)

              Container(

                margin:
                    EdgeInsets.only(
                  top: 25,
                ),

                padding:
                    EdgeInsets.all(18),

                decoration:
                    BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.black12,

                      blurRadius: 10,

                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(

                      children: [

                        Icon(

                          Icons.text_snippet,

                          color:
                              Color(0xFF3E6F55),
                        ),

                        SizedBox(width: 8),

                        Text(

                          "Texte détecté",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    Text(

                      result,

                      style: TextStyle(

                        fontSize: 15,

                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

            // =========================
            // MATCHED DOCUMENT
            // =========================

            if (matched &&
                matchedDocument != null)

              Container(

                margin:
                    EdgeInsets.only(
                  top: 25,
                ),

                padding:
                    EdgeInsets.all(20),

                decoration:
                    BoxDecoration(

                  color:
                      Colors.green[50],

                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),

                  border: Border.all(

                    color:
                        Colors.green.shade200,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.black12,

                      blurRadius: 10,

                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(

                      children: [

                        Icon(

                          Icons.verified,

                          color:
                              Colors.green,

                          size: 30,
                        ),

                        SizedBox(width: 10),

                        Text(

                          "Document trouvé",

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 20,

                            color:
                                Colors.green,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    infoTile(

                      Icons.person,

                      "${matchedDocument!['nom']} ${matchedDocument!['prenom']}",
                    ),

                    infoTile(

                      Icons.phone,

                      matchedDocument![
                          'telephone'],
                    ),

                    infoTile(

                      Icons.location_on,

                      matchedDocument![
                          'lieu_trouve'],
                    ),

                    infoTile(

                      Icons.badge,

                      matchedDocument![
                          'type_document'],
                    ),

                    SizedBox(height: 20),

                    // =========================
                    // APPELER
                    // =========================

                    actionButton(

                      color: Colors.green,

                      icon: Icons.call,

                      text: "Appeler",

                      onTap: () async {

                        final phone =
                            matchedDocument![
                                'telephone'];

                        await launchUrl(

                          Uri.parse(
                            "tel:$phone",
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    // =========================
                    // WHATSAPP
                    // =========================

                    actionButton(

                      color: Colors.green,

                      icon: Icons.message,

                      text: "WhatsApp",

                      onTap: () async {

                        final phone =
                            matchedDocument![
                                'telephone'];

                        await launchUrl(

                          Uri.parse(
                            "https://wa.me/222$phone",
                          ),

                          mode:
                              LaunchMode.externalApplication,
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    // =========================
                    // CHAT
                    // =========================

                    actionButton(

                      color: Colors.blue,

                      icon: Icons.chat,

                      text: "Discuter",

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                ChatScreen(

                              receiverId:
                                  matchedDocument![
                                      'user'],

                              receiverName:
                                  matchedDocument![
                                      'nom'],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    // =========================
                    // RETOURNE
                    // =========================

                    actionButton(

                      color: Colors.orange,

                      icon: Icons.check,

                      text:
                          "Marquer comme retourné",

                      onTap: () async {

                        final id =
                            matchedDocument![
                                'id'];

                        final response =
                            await http.post(

                          Uri.parse(
                            "http://127.0.0.1:8000/api/update-document-status/$id/",
                          ),
                        );

                        final data =
                            jsonDecode(
                          response.body,
                        );

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(

                          SnackBar(

                            content: Text(
                              data['message'],
                            ),
                          ),
                        );

                        setState(() {

                          matched = false;

                          matchedDocument =
                              null;
                        });
                      },
                    ),
                  ],
                ),
              ),

            // =========================
            // NO RESULT
            // =========================

            if (!matched &&
                result.isNotEmpty)

              Container(

                margin:
                    EdgeInsets.only(
                  top: 25,
                ),

                padding:
                    EdgeInsets.all(18),

                decoration:
                    BoxDecoration(

                  color:
                      Colors.red[50],

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(

                    color:
                        Colors.red.shade200,
                  ),
                ),

                child: Row(

                  children: [

                    Icon(

                      Icons.error,

                      color: Colors.red,
                    ),

                    SizedBox(width: 10),

                    Expanded(

                      child: Text(

                        "Aucun document trouvé",

                        style: TextStyle(

                          fontSize: 16,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================
  // ACTION BUTTON
  // =========================

  Widget actionButton({

    required Color color,

    required IconData icon,

    required String text,

    required VoidCallback onTap,

  }) {

    return SizedBox(

      width: double.infinity,

      child: ElevatedButton.icon(

        onPressed: onTap,

        icon: Icon(
          icon,
          color: Colors.white,
        ),

        label: Text(

          text,

          style: TextStyle(

            color: Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        style:
            ElevatedButton.styleFrom(

          backgroundColor: color,

          padding:
              EdgeInsets.symmetric(
            vertical: 15,
          ),

          elevation: 6,

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }
}