import 'package:firestore_record/route/routeString.dart';
import 'package:flutter/material.dart';

import '../../app_providers/authentication_provider.dart';
import '../../dependency_injection.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final _authProvider = sl<AuthenticationProvider>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade400,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                  onPressed: (){
                    _logOutSheet(onLogOutTap: (){
                      Navigator.pop(context);

                      _authProvider.logOut(context);
                    });
                  },
                  child: const Text("Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,

                    ),)),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteString.homeRoute);
                  },
                  child: const Text("Record")),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteString.chatHomeRoute);
                  },
                  child: const Text("Chat")),
            ],
          ),
        ),
      ),
    );
  }
  Future _logOutSheet({required VoidCallback onLogOutTap}){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(

            title: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: Column(
                children: [
                  const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 30.0),
                    child: Text(
                      "Are you sure you want to log out?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                  color: Colors
                                      .indigo.shade400),
                              child: const Center(
                                child: Text("No",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 14)),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.1,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: onLogOutTap,
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(10),
                                  color: Colors.red),
                              child: const Center(
                                  child: Text("Yes",
                                      style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          fontSize:
                                          14)))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
