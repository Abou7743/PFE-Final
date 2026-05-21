import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
    as http;

import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen
    extends StatefulWidget {

  final int receiverId;

  final String receiverName;

  ChatScreen({
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  bool isOnline = false;

  List messages = [];

  TextEditingController controller =
      TextEditingController();

  ScrollController scrollController =
      ScrollController();

  String senderId = "";

  @override
  void initState() {

    super.initState();

    loadMessages();

    loadStatus();
  }

  // 🟢 STATUS

  Future loadStatus() async {

    final response =
        await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/user-status/${widget.receiverId}/",
      ),
    );

    final data =
        jsonDecode(response.body);

    setState(() {

      isOnline =
          data['is_online'];
    });
  }

  // 💬 LOAD MESSAGES

  Future loadMessages() async {

    final prefs =
        await SharedPreferences.getInstance();

    senderId =
        prefs.getString("id") ?? "";

    final response =
        await http.get(

      Uri.parse(
        "http://127.0.0.1:8000/api/messages/$senderId/${widget.receiverId}/",
      ),
    );

    setState(() {

      messages =
          jsonDecode(response.body);
    });

    // 🔥 AUTO SCROLL

    Future.delayed(
      Duration(milliseconds: 300),
      () {

        if (scrollController.hasClients) {

          scrollController.animateTo(

            scrollController
                .position
                .maxScrollExtent,

            duration:
                Duration(milliseconds: 300),

            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  // 📤 SEND MESSAGE

  Future sendMessage() async {

    if (controller.text.trim().isEmpty) {
      return;
    }

    await http.post(

      Uri.parse(
        "http://127.0.0.1:8000/api/send-message/",
      ),

      body: {

        "sender": senderId,

        "receiver":
            widget.receiverId.toString(),

        "content":
            controller.text,
      },
    );

    controller.clear();

    loadMessages();
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
              25,
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
                    Radius.circular(30),
              ),
            ),

            child: Row(

              children: [

                CircleAvatar(

                  backgroundColor:
                      Colors.white24,

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

                CircleAvatar(

  radius: 24,

  backgroundColor:
      Colors.white,

  child: Text(

    widget.receiverName
        .substring(0, 1)
        .toUpperCase(),

    style: TextStyle(

      color: Color(0xFF3E6F55),

      fontWeight: FontWeight.bold,

      fontSize: 22,
    ),
  ),
),

                SizedBox(width: 15),

                Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      widget.receiverName,

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(

                      isOnline

                          ? "🟢 En ligne"

                          : "⚫ Hors ligne",

                      style: TextStyle(

                        color:
                            Colors.white70,

                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // 💬 MESSAGES

          Expanded(

            child: ListView.builder(

              controller:
                  scrollController,

              padding:
                  EdgeInsets.all(15),

              itemCount:
                  messages.length,

              itemBuilder:
                  (context, index) {

                final msg =
                    messages[index];

                bool isMe =

                    msg['sender']
                            .toString() ==

                        senderId;

                return Align(

                  alignment:

                      isMe

                          ? Alignment.centerRight

                          : Alignment.centerLeft,

                  child: Container(

                    constraints:
                        BoxConstraints(

                      maxWidth:
                          MediaQuery.of(
                                      context)
                                  .size
                                  .width *

                              0.75,
                    ),

                    margin:
                        EdgeInsets.only(
                      bottom: 12,
                    ),

                    padding:
                        EdgeInsets.symmetric(

                      horizontal: 16,

                      vertical: 12,
                    ),

                    decoration:
                        BoxDecoration(

                      color:

                          isMe

                              ? Color(
                                  0xFF3E6F55)

                              : Colors.white,

                      borderRadius:
                          BorderRadius.only(

                        topLeft:
                            Radius.circular(
                          20,
                        ),

                        topRight:
                            Radius.circular(
                          20,
                        ),

                        bottomLeft:

                            isMe

                                ? Radius.circular(
                                    20,
                                  )

                                : Radius.circular(
                                    5,
                                  ),

                        bottomRight:

                            isMe

                                ? Radius.circular(
                                    5,
                                  )

                                : Radius.circular(
                                    20,
                                  ),
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black12,

                          blurRadius: 5,

                          offset:
                              Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(

  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    Text(

      msg['content'],

      style: TextStyle(

        color:

            isMe

                ? Colors.white

                : Colors.black87,

        fontSize: 15,
      ),
    ),

    SizedBox(height: 5),

    if (isMe)

      Row(

        mainAxisAlignment:
            MainAxisAlignment.end,

        children: [

          Icon(

            msg['is_read']

                ? Icons.done_all

                : Icons.done,

            size: 18,

            color:

                msg['is_read']

                    ? Colors.lightBlueAccent

                    : Colors.white70,
          ),

          SizedBox(width: 4),

          Text(

            msg['is_read']

                ? "Vu"

                : "Envoyé",

            style: TextStyle(

              color:
                  Colors.white70,

              fontSize: 11,
            ),
          ),
        ],
      ),
  ],
),
                  ),
                );
              },
            ),
          ),

          // ✍️ INPUT

          SafeArea(

            child: Container(

              padding:
                  EdgeInsets.symmetric(

                horizontal: 12,

                vertical: 10,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                boxShadow: [

                  BoxShadow(

                    color: Colors.black12,

                    blurRadius: 8,
                  ),
                ],
              ),

              child: Row(

                children: [

                  Expanded(

                    child: Container(

                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 15,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.grey[200],

                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      child: TextField(

                        controller:
                            controller,

                        decoration:
                            InputDecoration(

                          border:
                              InputBorder.none,

                          hintText:
                              "Écrire un message...",
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  GestureDetector(

                    onTap: sendMessage,

                    child: Container(

                      padding:
                          EdgeInsets.all(14),

                      decoration:
                          BoxDecoration(

                        color:
                            Color(0xFF3E6F55),

                        shape:
                            BoxShape.circle,
                      ),

                      child: Icon(

                        Icons.send,

                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}