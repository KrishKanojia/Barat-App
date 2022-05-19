import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/auth_gate.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/splash.dart';
import 'package:barat/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'screens/confirm_order_screen.dart';
import 'screens/create_hall_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  Stripe.publishableKey =
      'pk_test_51JcaT0LtlAjb95NaxcGQoOIyNA6uVyozoNYErdxkxZW55zUFTudT70R41lHRUbCVC4pGveeSwg6wkQwrbinVDSbL00neGfIMQx';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin fltNotification =
      FlutterLocalNotificationsPlugin();
  void _requestPermissions() {
    fltNotification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    fltNotification
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> initMessaging() async {
    var androiInit =
        const AndroidInitializationSettings('drawable/ic_launcher');
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'channelName', 'channel Description',
            priority: Priority.high,
            importance: Importance.high,
            enableLights: true,
            playSound: true,
            color: Color(0xFF218bd4),
            icon: 'drawable/ic_launcher');
    await fltNotification.initialize(initSetting,
        onSelectNotification: (String? payload) async {});

    var iosDetails = const IOSNotificationDetails(presentSound: true);
    final NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosDetails,
    );
    //In app
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        fltNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          generalNotificationDetails,
        );
      }
    });
  }

  @override
  void initState() {
    _requestPermissions();
    initMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const providerConfigs = [
      EmailProviderConfiguration(),
      GoogleProviderConfiguration(
          clientId:
              '635513644699-ie5f0v2ir9gjpidnmv8f3m8dlhgldi3p.apps.googleusercontent.com'),
    ];
    print(box.read('responseLogin'));
    box.listenKey('responseSignUp', (value) {
      print('new key is $value');
    });
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Barat',
        theme: ThemeData(primarySwatch: deepOrange),
        home: const AuthGate(),
        // home: const AdminAreaForm(),
        // home: const AdminPage(),
        // home: box.read('responseSignUp') == null
        //     ? box.read('responseLogin') == null
        //         ? const LoginPage()
        //         : const HomePage()
        //     : const HomePage()

        // home: const HallsDetailForm(),
        // initialRoute: '/',
        initialRoute: SplashScreen.routeName,
        // FirebaseAuth.instance.currentUser == null
        //     ? LoginPage.routeName
        //     : HomePage.routeName,
        routes: {
          // '/': (context) => const AuthGate(),

          // '/sign-in': (context) {
          //   return SignInScreen(
          //     providerConfigs: providerConfigs,
          //     actions: [
          //       AuthStateChangeAction<SignedIn>((context, state) {
          //         Navigator.pushNamed(context, LoginPage.routeName);
          //       }),
          //     ],
          //   );
          // },
          '/profile': (context) {
            return ProfileScreen(
              providerConfigs: providerConfigs,
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }),
              ],
            );
          },
          LoginPage.routeName: (context) => const LoginPage(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomePage.routeName: (context) => const HomePage(),
          HallsDetailForm.routeName: (context) => const HallsDetailForm(),
          CreateHallUser.routeName: (context) => const CreateHallUser(),
          ConfirmOrderScreen.routeName: (context) => const ConfirmOrderScreen(),
        },
      ),
    );
  }
}
