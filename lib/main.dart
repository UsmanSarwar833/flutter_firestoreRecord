
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_record/app_providers/chat_provider.dart';
import 'package:firestore_record/app_providers/record_provider.dart';
import 'package:firestore_record/route/onGenerateRoute.dart';
import 'package:firestore_record/route/routeString.dart';
import 'package:flutter/material.dart';
import 'app_providers/authentication_provider.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


void main() async {
 // FirebaseAnalytics.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setup();
 // FirebaseFirestore.instance.settings = const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authProvider = sl<AuthenticationProvider>();
  final _recordProvider = sl<RecordProvider>();
  final _chatProvider = sl<ChatProvider>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _recordProvider),
        ChangeNotifierProvider.value(value: _chatProvider),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
           // useMaterial3: true,
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: _authProvider.getUserUId != null
              ? RouteString.mainRoute
              : RouteString.signInRoute),
    );
  }
}
