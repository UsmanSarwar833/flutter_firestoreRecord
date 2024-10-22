
import 'message_model.dart';

class  ChatModel {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  ChatModel({
     this.id,
     this.participants,
     this.messages,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages =
        List.from(json['messages']).map((m) => Message.fromJson(m)).toList();
  }
  ChatModel.empty() {
    id = "";
    participants = [];
    messages = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participants'] = participants;
    data['messages'] = messages?.map((m) => m.toJson()).toList() ?? [];
    return data;
  }
}