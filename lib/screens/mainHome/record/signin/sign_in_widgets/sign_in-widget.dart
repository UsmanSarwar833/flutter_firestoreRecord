import 'package:flutter/material.dart';

PreferredSize authAppBar(String appBarTitle) {
  return PreferredSize(
      preferredSize: const Size(double.infinity, 70),
      child: AppBar(
          backgroundColor: Colors.white,
          leading: const Text(""),
          title: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(appBarTitle,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.white,
                height: 1.0,
              ))));
}

Widget buildThirdPartyLogin(BuildContext context) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, bottom: 20, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLoginIcons("assets/icons/google.png", () {}),
                  _buildLoginIcons("assets/icons/apple.png", () {}),
                  _buildLoginIcons("assets/icons/facebook.png", () {}),
                ])),
        Text("Or use your email account login",
            style: TextStyle(color: Colors.grey.shade600))
      ]);
}

Widget _buildLoginIcons(String imagePath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(imagePath, fit: BoxFit.contain)),
  );
}

Widget formField(
    {required String hintText,
    required TextInputType keyboardType,
    required TextEditingController controller,
    required Function(String value) onValidator,
    required TextInputAction textInputAction,
    }) {
  return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 18),
      child: TextFormField(
        controller: controller,
        validator: (value) => onValidator(value!),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),

            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade400))),
        autocorrect: false,
       // obscureText: textType == "password" ? true : false,
      ));
}

Widget button(    TextStyle style, Color color, String buttonTitle, VoidCallback onTap) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: color,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(
              buttonTitle,
              style: style,
            )),
          )));
}

Widget formFieldTitle(String textTitle) {
  TextStyle fieldTitle = const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);

  return Text(textTitle, style: fieldTitle);
}



