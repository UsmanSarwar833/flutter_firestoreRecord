



String generateChatId({required String uid1,required String uid2}){

  List uIds = [uid1,uid2];
  //uIds.sort();
  String chatId = uIds.fold("", (id,uid) => "$id$uid");
  return chatId;

}