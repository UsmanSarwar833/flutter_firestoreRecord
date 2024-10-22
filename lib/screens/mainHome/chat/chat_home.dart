import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/app_providers/authentication_provider.dart';
import 'package:firestore_record/app_providers/chat_provider.dart';
import 'package:firestore_record/core/utils.dart';
import 'package:firestore_record/route/routeString.dart';
import 'package:firestore_record/screens/mainHome/chat/chatDetail/chat_screen.dart';
import 'package:firestore_record/source/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dependency_injection.dart';


class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {

  final chatProvider = sl<ChatProvider>();
  final authProvider = sl<AuthenticationProvider>();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0),(){
      chatProvider.getUserProfile();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    TextStyle title =  const TextStyle(fontWeight: FontWeight.bold,fontSize: 14);
    TextStyle detail =  const TextStyle(fontWeight: FontWeight.w500,fontSize: 17);
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat home screen",
          style: TextStyle(color: Colors.white),
        ),
        leading:  IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: Colors.white)),
        backgroundColor: Colors.indigo.shade400,
        centerTitle: true,
      ),
      body: Consumer<ChatProvider>(builder: (context,chatState,child){
        if(chatProvider.getProfileStatus == ChatStatus.loading){
          return const  Center(child: CircularProgressIndicator());
        }
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: chatState.userProfileList.isNotEmpty



              ? ListView.builder(
              itemCount: chatState.userProfileList.length,
              itemBuilder: (context,index){
                final data = chatState.userProfileList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                  child: GestureDetector(
                    onTap: ()async{
                     // final result = await chatProvider.checkChatStatus(uIds1: authProvider.getUserUId.toString(), uIds2: data.uId.toString());
                     //  if(!result){
                     //    final chatId = generateChatId(uid1: authProvider.getUserUId.toString(), uid2:  data.uId.toString());
                     //    chatProvider.addUserChat(
                     //        chatModel: ChatModel(
                     //          id: chatId,
                     //          participants: [authProvider.getUserUId.toString(),data.uId.toString()],
                     //          messages: []
                     //        ),
                     //        uIds1: authProvider.getUserUId.toString(),
                     //        uIds2: data.uId.toString()).then((success){});
                     //  }

                      Navigator.push(context, MaterialPageRoute(builder: (_) =>   ChatDetailScreen(userProfileModel: data)));
                     },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2), // changes position of shadow
                          ),
                        ],

                      ),
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration:  const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: AssetImage("assets/images/profileImage.jfif"))
                                    ),
                                  ),
                                  //Text("Name:   ",style: title),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: SizedBox(
                                      //color: Colors.red,
                                        width: MediaQuery.of(context).size.width * 0.65,
                                        child:  Text(data.name.toString(),style: detail,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  ),

                                ],
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text("User Id:   ",style: title),
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            //       child: SizedBox(
                            //         //color: Colors.red,
                            //           width: MediaQuery.of(context).size.width * 0.65,
                            //           child:  Text(data.uId.toString(),style: detail,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                            //     ),
                            //
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
              :  Center(child: Text("No user Found",style: title.copyWith(fontSize: 20),)),
        );
      })
    );
  }
}
