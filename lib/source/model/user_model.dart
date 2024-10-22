class UserProfileModel {
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  String? uId;

  UserProfileModel({this.name, this.email, this.password,this.confirmPassword,this.uId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['uId'] = uId;
    return data;
  }

  UserProfileModel.fromMap(Map<String, dynamic> data) {
    try {
      name = data['name'];
      email = data['email'];
      password = data['password'];
      confirmPassword = data['confirmPassword'];
      uId = data['uId'];
    } catch (e) {
      print("user ${e.toString()}");
    }
  }

  UserProfileModel.empty() {
    try {
      name = "";
      email = "";
      password = "";
      confirmPassword = "";
      uId = "";
    } catch (e) {
      print("user ${e.toString()}");
    }
  }
}
