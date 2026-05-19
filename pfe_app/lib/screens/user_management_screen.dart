import 'package:flutter/material.dart';

import '../services/api_service.dart';

class UserManagementScreen
    extends StatefulWidget {

  @override
  _UserManagementScreenState createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState
    extends State<UserManagementScreen> {

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

                      "Utilisateurs 👥",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(

                      "Gestion des utilisateurs",

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

          // 👥 USERS LIST

          Expanded(

            child:
                FutureBuilder<List<dynamic>>(

              future:
                  ApiService.fetchUsers(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final users =
                    snapshot.data!;

                return ListView.builder(

                  padding:
                      EdgeInsets.only(
                    bottom: 100,
                  ),

                  itemCount:
                      users.length,

                  itemBuilder:
                      (context, index) {

                    final user =
                        users[index];

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

                        children: [

                          // 👤 AVATAR

                          CircleAvatar(

                            radius: 30,

                            backgroundColor:
                                Color(
                              0xFF3E6F55,
                            ),

                            child: Text(

                              user['nom'][0]
                                  .toUpperCase(),

                              style: TextStyle(

                                color: Colors.white,

                                fontSize: 22,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(width: 15),

                          // 📄 INFOS

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  user['nom'],

                                  style: TextStyle(

                                    fontSize: 18,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 6),

                                Text(

                                  user['email'],

                                  style: TextStyle(

                                    color:
                                        Colors.grey[700],
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(

                                  user['telephone'],

                                  style: TextStyle(

                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✏️ EDIT

                          IconButton(

                            icon: Icon(

                              Icons.edit,

                              color: Colors.blue,
                            ),

                            onPressed: () {

                              TextEditingController
                                  nomController =

                                  TextEditingController(

                                text:
                                    user['nom'],
                              );

                              TextEditingController
                                  emailController =

                                  TextEditingController(

                                text:
                                    user['email'],
                              );

                              TextEditingController
                                  telController =

                                  TextEditingController(

                                text:
                                    user['telephone'],
                              );

                              showDialog(

                                context: context,

                                builder: (context) {

                                  return AlertDialog(

                                    shape:
                                        RoundedRectangleBorder(

                                      borderRadius:
                                          BorderRadius.circular(
                                        25,
                                      ),
                                    ),

                                    title: Text(
                                      "Modifier utilisateur",
                                    ),

                                    content: Column(

                                      mainAxisSize:
                                          MainAxisSize.min,

                                      children: [

                                        TextField(

                                          controller:
                                              nomController,

                                          decoration:
                                              InputDecoration(

                                            labelText:
                                                "Nom",
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        TextField(

                                          controller:
                                              emailController,

                                          decoration:
                                              InputDecoration(

                                            labelText:
                                                "Email",
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        TextField(

                                          controller:
                                              telController,

                                          decoration:
                                              InputDecoration(

                                            labelText:
                                                "Téléphone",
                                          ),
                                        ),
                                      ],
                                    ),

                                    actions: [

                                      TextButton(

                                        onPressed: () {

                                          Navigator.pop(
                                            context,
                                          );
                                        },

                                        child: Text(
                                          "Annuler",
                                        ),
                                      ),

                                      ElevatedButton(

                                        style:
                                            ElevatedButton.styleFrom(

                                          backgroundColor:
                                              Color(
                                            0xFF3E6F55,
                                          ),
                                        ),

                                        onPressed: () async {

                                          await ApiService.updateUser(

                                            user['id'],

                                            nomController.text,

                                            emailController.text,

                                            telController.text,
                                          );

                                          Navigator.pop(
                                            context,
                                          );

                                          setState(() {});
                                        },

                                        child: Text(
                                          "Sauver",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                          // 🗑️ DELETE

                          IconButton(

                            icon: Icon(

                              Icons.delete,

                              color: Colors.red,
                            ),

                            onPressed: () async {

                              bool? confirm =
                                  await showDialog(

                                context: context,

                                builder: (context) {

                                  return AlertDialog(

                                    shape:
                                        RoundedRectangleBorder(

                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),

                                    title: Text(
                                      "Suppression",
                                    ),

                                    content: Text(
                                      "Supprimer cet utilisateur ?",
                                    ),

                                    actions: [

                                      TextButton(

                                        onPressed: () {

                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },

                                        child: Text(
                                          "Non",
                                        ),
                                      ),

                                      TextButton(

                                        onPressed: () {

                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },

                                        child: Text(
                                          "Oui",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {

                                await ApiService.deleteUser(

                                  user['id'],
                                );

                                await ApiService.addLog(

                                  "Utilisateur supprimé",
                                );

                                setState(() {});
                              }
                            },
                          ),
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

      // ➕ ADD USER

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            Color(0xFF3E6F55),

        icon: Icon(Icons.add),

        label: Text(
          "Ajouter",
        ),

        onPressed: () {

          TextEditingController nom =
              TextEditingController();

          TextEditingController email =
              TextEditingController();

          TextEditingController tel =
              TextEditingController();

          TextEditingController pass =
              TextEditingController();

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),
                ),

                title: Text(
                  "Créer utilisateur",
                ),

                content: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    TextField(

                      controller: nom,

                      decoration:
                          InputDecoration(
                        labelText: "Nom",
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(

                      controller: email,

                      decoration:
                          InputDecoration(
                        labelText: "Email",
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(

                      controller: tel,

                      decoration:
                          InputDecoration(
                        labelText: "Téléphone",
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(

                      controller: pass,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Mot de passe",
                      ),
                    ),
                  ],
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },

                    child: Text(
                      "Annuler",
                    ),
                  ),

                  ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Color(0xFF3E6F55),
                    ),

                    onPressed: () async {

                      await ApiService.addUser(

                        nom.text,

                        email.text,

                        tel.text,

                        pass.text,
                      );

                      Navigator.pop(
                        context,
                      );

                      setState(() {});
                    },

                    child: Text(
                      "Créer",
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}