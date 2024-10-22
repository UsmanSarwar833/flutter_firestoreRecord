import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firestore_record/app_providers/authentication_provider.dart';
import 'package:firestore_record/app_providers/chat_provider.dart';
import 'package:firestore_record/dependency_injection.dart';
import 'package:firestore_record/source/model/chat_model.dart';
import 'package:firestore_record/source/model/message_model.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils.dart';

class ChatDetailScreen extends StatefulWidget {
  final UserProfileModel userProfileModel;

  const ChatDetailScreen({super.key, required this.userProfileModel});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final authPro = sl<AuthenticationProvider>();
  final chatPro = sl<ChatProvider>();

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
        id: authPro.getUserUId.toString(),
        firstName: authPro.getUserName,
       profileImage: "assets/images/profileImage.jfif",
    );
    otherUser = ChatUser(
        id: widget.userProfileModel.uId.toString(),
        firstName: widget.userProfileModel.name.toString(),
        profileImage: "assets/images/profileImage.jfif",
    );
    WidgetsBinding.instance .addPostFrameCallback((_) {
      chatPro.getChat(uId1: authPro.getUserUId.toString(), uId2: widget.userProfileModel.uId.toString());});
  }

  Future<void> _sendMessage(ChatMessage chatMessage)async{
    print("Send message");
    Message message = Message(
        senderID: authPro.getUserUId,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt)
    );

    final result = await chatPro.checkChatStatus(uIds1: authPro.getUserUId.toString(), uIds2: widget.userProfileModel.uId.toString());
     if(!result){
       final chatId = generateChatId(uid1: authPro.getUserUId.toString(), uid2:  widget.userProfileModel.uId.toString());
      await chatPro.addUserChat(  chatModel: ChatModel(
             id: chatId,
             participants: [authPro.getUserUId.toString(), widget.userProfileModel.uId.toString()],
             messages: [message],
           ), uIds1: authPro.getUserUId.toString(), uIds2:  widget.userProfileModel.uId.toString()).then((success){});
     }else{
    await chatPro.sendChat(uId1: authPro.getUserUId.toString(), uId2: widget.userProfileModel.uId.toString(), message: message);
   }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/profileImage.jfif")))),
            const SizedBox(width: 10),
            Text(widget.userProfileModel.name.toString(),
                style: const TextStyle(color: Colors.white))
          ]),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
          backgroundColor: Colors.indigo.shade400,
          centerTitle: false),
      body:  streamList(),


    );
  }

  Widget streamList(){
    if(chatPro.chatModel == null) return const Center(child: CircularProgressIndicator()) ;

    return  StreamBuilder(
        stream:   chatPro.chatModel!.snapshots(),
        builder: (context,snapShot){

          ChatModel chat = ChatModel.fromJson(snapShot.data!.data()!);
          List<ChatMessage> message = [];
          if(chat.messages!.isEmpty) return const Text("not message found");
          if(snapShot.hasError) return const Text("not found");

          if(chat.messages != null) {
            message = _generateChatMessageList(chat.messages!);
          }
          return  DashChat(
              messageOptions: const MessageOptions(
                  showOtherUsersAvatar: true,
                  showTime: true
              ),
              inputOptions: const InputOptions(alwaysShowSend: true),
              currentUser: currentUser!,
              onSend: _sendMessage,
              messages: message);


        });
  }

  List<ChatMessage> _generateChatMessageList(List<Message> messages){
    List<ChatMessage> chatMessages = messages.map((m){
      return ChatMessage(
          user: m.senderID == authPro.getUserUId! ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate());
    }).toList();
    return chatMessages;
  }


}

