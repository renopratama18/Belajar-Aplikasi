import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart'; // Ganti dengan file Firebase Options Anda
import 'routes/routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Plugin untuk notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// Referensi ke Firebase Realtime Database
final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

// Fungsi utama aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding widget sudah siap
  await _initializeFirebase(); // Inisialisasi Firebase
  await _initializeLocalNotifications(); // Inisialisasi notifikasi lokal
  await initializeDateFormatting('id_ID', null); // Inisialisasi format tanggal

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Daftarkan handler untuk pesan di background
  _initializeFCM(); // Inisialisasi FCM
  _setupFirebaseListeners(); // Daftarkan listener Firebase Database

  runApp(MyApp()); // Jalankan aplikasi
}

// Fungsi untuk inisialisasi Firebase
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }
}

// Fungsi untuk inisialisasi notifikasi lokal
Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        print('Notification payload: ${response.payload}');
        // Logika tambahan untuk menangani payload
      }
    },
  );

  // Membuat channel notifikasi (hanya untuk Android)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id', // id channel
    'your_channel_name', // nama channel
    description: 'your channel description', // deskripsi channel
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Inisialisasi Firebase Cloud Messaging
void _initializeFCM() {
  
  FirebaseMessaging.instance.getToken().then((token) {
    print('FCM Token: $token');
    // Kirim token ke server jika diperlukan
  });

  // Handler untuk pesan ketika aplikasi berada di foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message while in the foreground: ${message.messageId}');
    _showNotification(
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
    );
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// Handler untuk pesan ketika aplikasi berada di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Pastikan Firebase sudah diinisialisasi
  print('Handling a background message: ${message.messageId}');

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your_channel_id', 'your_channel_name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    platformChannelSpecifics,
    payload: message.data['payload'],
  );
}

// Setup listener Firebase Realtime Database
void _setupFirebaseListeners() {
  _databaseReference.child('fuelinformation/status').onValue.listen(
    (event) {
      final int status = event.snapshot.value as int? ?? 0;
      if (status == 1) {
        _showNotification('Status Genset', 'Genset Menyala');
      } else {
        _showNotification('Status Genset', 'Genset Mati');
      }
    },
    onError: (error) {
      print('Error: $error');
    },
  );
}

// Fungsi untuk menampilkan notifikasi
Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your_channel_id', 'your_channel_name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  try {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  } catch (e) {
    print('Notification Error: $e');
  }
}

// Kelas utama aplikasi
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.dashboard : Routes.splash,
      routes: Routes.routes,
    );
  }
}
