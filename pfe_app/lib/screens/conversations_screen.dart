import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class ConversationsScreen
    extends StatefulWidget {

  @override
  State<ConversationsScreen>
      createState() =>

          _ConversationsScreenState();
}

class _ConversationsScreenState
    extends State<ConversationsScreen> {

  List conversations = [];

  @override
  void initState() {

    super.initState();

    loadConversations();
  }

  // 💬 LOAD CONVERSATIONS

  Future loadConversations() async {

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("id") ?? "";

    final response =
        await http.get(

      Uri.parse(
        "http://192.168.80.68:8000/api/conversations/$userId/",
      ),
    );

    setState(() {

      conversations =
          jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F6F8),

      body: Column(

        children: [

          // 🔹 HEADER

          Container(

            padding:
                EdgeInsets.fromLTRB(
              20,
              55,
              20,
              30,
            ),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Color(0xFF3E6F55),

                  Color(0xFF2E5A44),
                ],
              ),

              borderRadius:
                  BorderRadius.vertical(

                bottom:
                    Radius.circular(35),
              ),
            ),

            child: Row(

              children: [

                Container(

                  decoration: BoxDecoration(

                    color: Colors.white24,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: IconButton(

                    icon: Icon(

                      Icons.arrow_back,

                      color: Colors.white,
                    ),

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ),

                SizedBox(width: 15),

                Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Discussions 💬",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "${conversations.length} conversation(s)",

                      style: TextStyle(

                        color:
                            Colors.white70,

                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          // 💬 LISTE

          Expanded(

            child: conversations.isEmpty

                ? Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.chat_bubble_outline,

                          size: 90,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucune discussion 💬",

                          style: TextStyle(

                            fontSize: 18,

                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )

                : ListView.builder(

                    padding:
                        EdgeInsets.only(
                      bottom: 20,
                    ),

                    itemCount:
                        conversations.length,

                    itemBuilder:
                        (context, index) {

                      final conv =
                          conversations[index];

                      return GestureDetector(

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  ChatScreen(

                                receiverId:
                                    conv['user_id'],
                                receiverName:
                                    conv['nom'],
                              ),
                            ),
                          );
                        },

                        child: Container(

                          margin:
                              EdgeInsets.symmetric(

                            horizontal: 18,

                            vertical: 8,
                          ),

                          padding:
                              EdgeInsets.all(
                            15,
                          ),

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

                                blurRadius: 8,

                                offset:
                                    Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Row(

                            children: [

                              // 👤 AVATAR

                              Stack(

                                children: [

                                  CircleAvatar(

                                    radius: 30,

                                    backgroundColor:
                                        Color(
                                      0xFF3E6F55,
                                    ),

                                    child: Icon(

                                      Icons.person,

                                      color:
                                          Colors.white,

                                      size: 32,
                                    ),
                                  ),

                                  Positioned(

                                    right: 2,
                                    bottom: 2,

                                    child: Container(

                                      width: 14,
                                      height: 14,

                                      decoration:
                                          BoxDecoration(

                                        color:
                                            Colors.green,

                                        shape:
                                            BoxShape.circle,

                                        border:
                                            Border.all(

                                          color:
                                              Colors.white,

                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 15),

                              // 💬 INFOS

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(

                                      conv['nom'],

                                      style: TextStyle(

                                        fontSize: 17,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(

                                      conv['last_message'],

                                      maxLines: 1,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style: TextStyle(

                                        color:
                                            Colors.grey[700],

                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ➡️

                              Icon(

                                Icons.arrow_forward_ios,

                                color: Colors.grey,

                                size: 18,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}