import 'package:flutter/material.dart';
import 'screens/Widgets/welcome.dart';
import 'screens/Login/login.dart';
import 'screens/content/home_screen.dart';
import 'screens/content/payment_screen.dart';
import 'screens/content/chat_screen.dart';
import 'screens/form/form_tukang.dart';
import 'screens/Widgets/bottom_navigation.dart';
import 'screens/main_container.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // halaman pertama
      routes: {
        '/': (context) => const Welcome(), 
        '/login': (context) => const LoginScreen(),
        '/formtukang': (context) => const FormTukang(),
        '/HomeScreen': (context) => const HomeScreen(), 
        '/ChatScreen': (context) => const ChatScreen(), 
        '/PaymentScreen': (context) => const PaymentScreen(),
        '/bottom_navigation': (context) => const BottomNavigation(),
        '/main_container': (context) => const MainContainer(),
      },
    );
  }
}