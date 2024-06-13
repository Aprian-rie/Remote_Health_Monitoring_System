import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remote_health/utils/utils.dart';
import 'models/provider.dart';
import 'login_screen.dart'; // Import LoginScreen class from separate file
import 'dashboard.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await registerServices();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserImageProvider()),
          ],
      child: const MyApp(),
      ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote HMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: FirebaseAuth.instance.currentUser == null
      ? LoginScreen(title: 'Remote Health')
      : Dashboard(),
    );
  }
}
