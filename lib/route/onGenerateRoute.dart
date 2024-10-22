import 'package:firestore_record/route/routeString.dart';
import 'package:firestore_record/screens/mainHome/chat/chatDetail/chat_screen.dart';
import 'package:firestore_record/screens/mainHome/chat/chat_home.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:flutter/material.dart';
import '../screens/mainHome/record/addRecord/add_record.dart';
import '../screens/mainHome/record/addRecord/audioRecord/audio_recorder.dart';
import '../screens/mainHome/record/home/home_screen.dart';
import '../screens/mainHome/record/signin/sign_in.dart';
import '../screens/mainHome/record/signup/sign_up.dart';
import '../screens/mainHome/main_home_screen.dart';



class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteString.signInRoute: return MaterialPageRoute(builder: (_) =>  const SignInScreen());
      case RouteString.signUpRoute: return MaterialPageRoute(builder: (_) =>  const SignUpScreen());
      case RouteString.homeRoute: return MaterialPageRoute(builder: (_) =>  const RecordHomeScreen());
      case RouteString.addHomeRoute: return MaterialPageRoute(builder: (_) =>  const AddRecordScreen());
      case RouteString.mainRoute: return MaterialPageRoute(builder: (_) =>   const MainHome());
      case RouteString.audioRoute: return MaterialPageRoute(builder: (_) =>  const NewRecording());
      case RouteString.chatHomeRoute: return MaterialPageRoute(builder: (_) =>  const ChatHomeScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}