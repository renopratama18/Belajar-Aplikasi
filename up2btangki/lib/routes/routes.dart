import 'package:flutter/material.dart';
import 'package:up2btangki/pages/history.dart';
import 'package:up2btangki/pages/splashscreen.dart';
import 'package:up2btangki/pages/dashboard.dart';
import 'package:up2btangki/pages/login.dart';
import 'package:up2btangki/pages/info.dart';
import 'package:up2btangki/pages/riwayatgenset.dart';
import 'package:up2btangki/pages/addriwayatgenset.dart';
import 'package:up2btangki/pages/profile.dart';
import 'package:up2btangki/pages/historybulan.dart';




class Routes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String history = '/history';
  static const String info = '/info';
  static const String loginscreen = '/loginscreen';
  static const String riwayatgenset = '/riwayatgenset';
  static const String addriwayatgenset = '/addriwayatgenset';
  static const String profile = '/profile';
  static const String historybulan ='/historybulan';


  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    dashboard: (context) => DashboardPage(),
    history: (context) => HistoryPage(),
    info: (context) => InfoPage(),
    loginscreen : (context) => LoginScreen(),
    // riwayatgenset: (context) => RiwayatGenset(),
    addriwayatgenset: (context) => AddRiwayatGenset(),
    // settings: (context) => SettingsPage(),
    // ubahkode:(context) => UbahKode(username: ModalRoute.of(context)!.settings.arguments as String),
    historybulan: (context) => HistoryBulanPage(),
    // profile: (context) {
    //   final username = ModalRoute.of(context)!.settings.arguments as String?;
    //   return ProfilePage(username: username ?? '');  // Ensure username is passed correctly
  //  profile: (context) {
  //     final username = ModalRoute.of(context)?.settings.arguments as String?;
  //     return ProfilePage(username: username ?? '');
  //   },
    

  };
}
