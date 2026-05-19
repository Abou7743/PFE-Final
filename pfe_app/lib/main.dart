import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/document_screen.dart';
import 'screens/add_objet_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mes_publications_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/user_management_screen.dart';
import 'screens/centre_management_screen.dart';
import 'screens/zone_management_screen.dart';
import 'screens/admin_logs_screen.dart';
import 'screens/content_management_screen.dart';
import 'screens/ia_match_admin_screen.dart';
import 'screens/add_document_screen.dart';
import 'screens/search_document_screen.dart';
import 'screens/ocr_document_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),

      themeMode: ThemeMode.system,

      routes: {

        // 🔥 ROUTE PRINCIPALE AVEC CHECK LOGIN
        '/': (context) => FutureBuilder(
          future: checkLogin(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            bool isLoggedIn = snapshot.data as bool;

            return isLoggedIn ? HomeScreen() : LoginScreen();
          },
        ),

        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/documents': (context) => DocumentScreen(),
        '/add-objet': (context) => AddObjetScreen(),
        '/profile': (context) => ProfileScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/edit-profile': (context) => EditProfileScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/mes-publications': (context)=> MesPublicationsScreen(),
        '/notifications': (context)=> NotificationsScreen(),
        '/admin': (context)=> AdminDashboard(),
        '/users-admin':(context)=>UserManagementScreen(),
        '/centres-admin':(context)=>CentreManagementScreen(),
        '/zones-admin':(context)=>ZoneManagementScreen(),
        '/logs-admin':(context)=>AdminLogsScreen(),
        '/content-admin':(context)=>ContentManagementScreen(),
        '/ia-admin':(context)=>IAMatchAdminScreen(),
        '/add-document': (context) =>AddDocumentScreen(),
        '/search-document': (context) =>SearchDocumentScreen(),
        '/ocr-document': (context) =>OCRDocumentScreen(),
      },
    );
  }
}

// 🔥 FONCTION CHECK LOGIN
Future<bool> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn") ?? false;
}