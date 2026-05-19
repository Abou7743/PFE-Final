import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IAMatchAdminScreen
 extends StatefulWidget{

 @override
 _IAMatchAdminScreenState
 createState()=>
 _IAMatchAdminScreenState();

}

class _IAMatchAdminScreenState
 extends State<IAMatchAdminScreen>{

 Future<List<dynamic>>
 fetchMatches() async{

   final response=
     await http.get(
      Uri.parse(
       "http://127.0.0.1:8000/api/match/"
      ),
   );

   return jsonDecode(
     response.body
   );

 }

 @override
 Widget build(BuildContext context){

  return Scaffold(
   appBar:AppBar(
    title:Text(
      "Correspondances IA"
    ),
    backgroundColor:
      Color(0xFF3E6F55),
   ),

   body:FutureBuilder<List<dynamic>>(
    future:fetchMatches(),

    builder:(context,snapshot){

      if(!snapshot.hasData){
        return Center(
         child:
          CircularProgressIndicator(),
        );
      }

      final matches=
        snapshot.data!;

        if(matches.isEmpty){
          return Center(
            child:Text(
              "Aucune correspondance IA trouvée"
            ),
          );
        }

      return ListView.builder(
       itemCount:
         matches.length,

       itemBuilder:(context,index){

        final m=
         matches[index];

        return Card(
         margin:
          EdgeInsets.all(12),

         child:ListTile(

          leading:Icon(
           Icons.psychology,
           color:Colors.green,
          ),

          title:Text(
            "${m['objet']} ↔ ${m['document']}"
          ),

          subtitle:Text(
            "Score IA ${m['score']}%"
          ),

          trailing:
           ElevatedButton(
            onPressed:(){
              ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content:Text(
                      "Correspondance validée"
                    ),
                  ),
                );
              },
            child:Text(
              "Valider"
            ),
          ),

         ),
        );

       },
      );

    },
   ),
  );

 }

}