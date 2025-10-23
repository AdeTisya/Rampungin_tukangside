import 'package:flutter/material.dart';
import 'screens/Widgets/welcome.dart';
import 'screens/Login/login.dart';
import 'screens/content_bottom/home_screen.dart';
import 'screens/content_bottom/payment_screen.dart';
import 'screens/content_bottom/chat_screen.dart';
import 'screens/form/form_tukang.dart';
import 'screens/Widgets/bottom_navigation.dart';
import 'screens/main_container.dart';
import 'screens/detail/detail_order.dart';
import 'screens/detail/profile.dart';
import 'screens/detail/notification.dart';
import 'screens/detail/setting.dart';


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
        '/detail_order': (context) => const DetailOrder(),
        '/profile': (context) => Profile(),
        '/notification': (context) => const NotificationScreen(),
        '/setting': (context) => Setting(),
      },
    );
  }
}