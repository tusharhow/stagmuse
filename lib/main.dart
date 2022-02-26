import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:sizer/sizer.dart';

import 'view/page/main/podcast/see_podcast.dart';

// Global Key
final navigatorKey = GlobalKey<NavigatorState>();

// Notification
Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Important Notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  // Notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

// Theme
class CustomTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: colorBackground,
      backgroundColor: colorBackground,
      dialogBackgroundColor: colorBackground,
      popupMenuTheme: PopupMenuThemeData(
        color: colorBackground,
        textStyle: medium14(colorThird),
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: colorBackground),
      colorScheme: const ColorScheme.light().copyWith(
        primary: colorPrimary,
        secondary: colorSecondary,
        onSurface: colorThird,
        background: colorBackground,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
    );
  }
}

// App
class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Create Ads
    adsServices.createRewardedAd();
    adsServices.createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavigationBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => ExitAppBloc()),
        BlocProvider(create: (_) => ProfilePopMenuBloc()),
        BlocProvider(create: (_) => CommentBloc()),
        BlocProvider(create: (_) => EditProfileBloc()),
        BlocProvider(create: (_) => PostTypeBloc()),
        BlocProvider(create: (_) => PostFileBloc()),
        BlocProvider(create: (_) => StoryCommentBloc()),
        BlocProvider(create: (_) => BackendResponseBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(create: (_) => NotificationBloc()),
        BlocProvider(create: (_) => StoryControllBloc()),
        BlocProvider(create: (_) => LiveEventBloc()),
        BlocProvider(create: (_) => LiveImageBloc()),
      ],
      child: Sizer(
        builder: (_, __, ___) => AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: "Stagemuse Fashion",
            theme: CustomTheme.lightTheme(context),
            debugShowCheckedModeBanner: false,
            home: const LandingPage(),
          ),
        ),
      ),
    );
  }
}
