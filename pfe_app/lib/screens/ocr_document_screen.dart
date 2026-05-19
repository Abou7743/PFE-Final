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

  XFile? image;

  bool loading = false;

  String result = "";

  Map? matchedDocument;

  bool matched = false;

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
      print(data);
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

  Widget info(String text) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 8,
      ),

      child: Text(

        text,

        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "OCR IA 🤖",
        ),

        backgroundColor:
            Color(0xFF3E6F55),
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 220,

                width: double.infinity,

                decoration: BoxDecoration(

                  border: Border.all(
                    color: Colors.grey,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),

                child: image == null

                    ? Column(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Choisir une image",
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
                              15,
                            ),

                            child: Image.memory(

                              snapshot.data!,

                              fit: BoxFit.cover,

                              width:
                                  double.infinity,

                              height: 220,
                            ),
                          );
                        },
                      ),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                //onPressed: scanOCR,
                onPressed: () {

                  print("SCAN CLICK");

                  scanOCR();
                },

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Color(0xFF3E6F55),

                  padding:
                      EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                child: Text(
                  "Scanner Document",
                ),
              ),
            ),

            SizedBox(height: 20),

            if (loading)
              CircularProgressIndicator(),

            Expanded(

              child: SingleChildScrollView(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "📄 Texte détecté",

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(result),

                    SizedBox(height: 25),

                    if (matched &&
                        matchedDocument != null)

                      Container(

                        padding:
                            EdgeInsets.all(15),

                        decoration:
                            BoxDecoration(

                          color:
                              Colors.green[100],

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              "✅ Document trouvé",

                              style: TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 15),

                            info(
                              "👤 ${matchedDocument!['nom']} ${matchedDocument!['prenom']}",
                            ),

                            info(
                              "📞 ${matchedDocument!['telephone']}",
                            ),

                            info(
                              "📍 ${matchedDocument!['lieu_trouve']}",
                            ),

                            info(
                              "🪪 ${matchedDocument!['type_document']}",
                            ),

                            SizedBox(height: 15),

                            SizedBox(

                              width: double.infinity,

                              child:
                                  ElevatedButton.icon(

                                onPressed:
                                    () async {

                                  final phone =
                                      matchedDocument![
                                          'telephone'];

                                  final url =
                                      "tel:$phone";

                                  await launchUrl(
                                    Uri.parse(url),
                                  );
                                },

                                icon: Icon(
                                  Icons.call,
                                ),

                                label: Text(
                                  "📞 Appeler",
                                ),

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.green,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            SizedBox(

                              width: double.infinity,

                              child:
                                  ElevatedButton.icon(

                                onPressed:
                                    () async {

                                  final phone =
                                      matchedDocument![
                                          'telephone'];

                                  final url =
                                      "https://wa.me/222$phone";

                                  await launchUrl(

                                    Uri.parse(url),

                                    mode:
                                        LaunchMode.externalApplication,
                                  );
                                },

                                icon: Icon(
                                  Icons.message,
                                ),

                                label: Text(
                                  "💬 WhatsApp",
                                ),

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.green,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            SizedBox(

                              width: double.infinity,

                              child:
                                  ElevatedButton.icon(

                                onPressed: () {

                                  Navigator.push(

                                    context,

                                    MaterialPageRoute(

                                      builder: (_) =>
                                          ChatScreen(

                                        receiverId:
                                            matchedDocument![
                                                'user'],
                                      ),
                                    ),
                                  );
                                },

                                icon: Icon(
                                  Icons.chat,
                                ),

                                label: Text(
                                  "💬 Discuter",
                                ),

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.blue,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            SizedBox(

                              width: double.infinity,

                              child:
                                  ElevatedButton.icon(

                                onPressed:
                                    () async {

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
                                },

                                icon: Icon(
                                  Icons.check,
                                ),

                                label: Text(
                                  "✅ Marquer comme retourné",
                                ),

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (!matched &&
                        result.isNotEmpty)

                      Container(

                        padding:
                            EdgeInsets.all(15),

                        decoration:
                            BoxDecoration(

                          color:
                              Colors.red[100],

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),

                        child: Text(

                          "❌ Aucun document trouvé",

                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}