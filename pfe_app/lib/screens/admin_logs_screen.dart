import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AdminLogsScreen
    extends StatefulWidget {

  @override
  _AdminLogsScreenState createState() =>
      _AdminLogsScreenState();
}

class _AdminLogsScreenState
    extends State<AdminLogsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Color(0xFFF4F6F8),

      body: Column(

        children: [

          // 🔹 HEADER

          Container(

            width: double.infinity,

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

                      "Logs Admin 📜",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Historique des actions admin",

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

          SizedBox(height: 15),

          // 📜 LOGS LIST

          Expanded(

            child:
                FutureBuilder<List<dynamic>>(

              future:
                  ApiService.fetchLogs(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final logs =
                    snapshot.data!;

                if (logs.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Icon(

                          Icons.history,

                          size: 90,

                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Aucun log 📜",

                          style: TextStyle(

                            fontSize: 18,

                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(

                  padding:
                      EdgeInsets.only(
                    bottom: 20,
                  ),

                  itemCount:
                      logs.length,

                  itemBuilder:
                      (context, index) {

                    final log =
                        logs[index];

                    return Container(

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
                          25,
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

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // 📜 ICON

                          Container(

                            padding:
                                EdgeInsets.all(
                              15,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Color(0xFF3E6F55)
                                      .withOpacity(
                                0.15,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),

                            child: Icon(

                              Icons.history,

                              color:
                                  Color(0xFF3E6F55),

                              size: 32,
                            ),
                          ),

                          SizedBox(width: 15),

                          // 📄 LOG INFOS

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  log['action'],

                                  style: TextStyle(

                                    fontSize: 17,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Row(

                                  children: [

                                    Icon(

                                      Icons.access_time,

                                      size: 18,

                                      color:
                                          Colors.grey,
                                    ),

                                    SizedBox(width: 5),

                                    Expanded(

                                      child: Text(

                                        log['date_action'],

                                        style: TextStyle(

                                          color:
                                              Colors.grey[700],

                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}