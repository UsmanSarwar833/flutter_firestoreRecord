

class AddRecordModel{
  String? about;
  String? code;
  String? name;
  String? number;
  String? date;
  String? time;
  String? audioPath;
  List<String>? img;
  List<String>? video;
  List<String>? thumbnail;


  AddRecordModel({this.about, this.code, this.name, this.number,this.date,this.time,this.audioPath,this.img,this.video,this.thumbnail});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['code'] = code;
    data['name'] = name;
    data['number'] = number;
    data['date'] = date;
    data['time'] = time;
    data['audioPath'] = audioPath;
    data['images'] = img;
    data['videos'] = video;
    data['thumbnail'] = thumbnail;
    return data;
  }


  AddRecordModel.fromJson(Map<String, dynamic> json){
    try{
      about = json['about'] ;
      code = json['code'] ;
      name = json['name'] ;
      number = json['number'] ;
      date = json['date'] ;
      time = json['time'];
      audioPath = json['audioPath'];
      img = json['images'].cast<String>() ;
      video = json['videos'].cast<String>();
      thumbnail = json['thumbnail'].cast<String>();
    }catch(e){
      print("add user record model $e");
    }
  }

  AddRecordModel.empty(){
    try{
      about = "" ;
      code = "" ;
      name = "" ;
      number = "" ;
      date = "" ;
      time = "";
      audioPath = "";
      img = [];
      video = [];
      thumbnail = [];
    }catch(e){
      print("add user record model $e");
    }
  }


}