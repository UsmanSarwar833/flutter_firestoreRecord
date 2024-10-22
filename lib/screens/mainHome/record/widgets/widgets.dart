import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'cacheImage.dart';

Widget customTextField(
    {
      required TextEditingController controller,
      required String hintText,
      VoidCallback? onTap,
       Function(String value)? onValidator,

      bool readOnly = false,
      Widget? prefix,
      String? comingFrom,
      IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      readOnly: readOnly,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: (value) => onValidator!(value!),
      maxLength: comingFrom == 'password' ? 10 : null,
      keyboardType: comingFrom == 'password' ? TextInputType.phone : TextInputType.name,
      decoration: InputDecoration(
          suffixIcon: GestureDetector(onTap: onTap, child: Icon(icon)),
          prefixIcon: prefix,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400))),
    ),
  );
}

 Widget list({ File? image,VoidCallback? onRemoveListTap,Uint8List? video,String? comingFrom,String? comingFromPage,String? networkImage}){
  return Padding(
    padding: const EdgeInsets.only(right: 5.0),
    child: Stack(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 65,
            width: 65,
            decoration:  BoxDecoration(

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],

              //color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: comingFrom == "video"
              ? Image.memory(video!,fit: BoxFit.cover,)
              : comingFrom == "image"
              ? CachedImage(url: networkImage,boxFit: BoxFit.cover,)
              //Image.network(networkImage.toString(),fit: BoxFit.cover,)
              : Image.file(image!,fit: BoxFit.cover,),
            ),
          ),
        ),

        comingFromPage == 'detail'
        ? Container()
        : Positioned(
          right: 0,
          top:0,
          child: GestureDetector(
            onTap: onRemoveListTap,
            child: Container(
              height: 15,
              width: 15,
              decoration: const BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(0))
              ),
              child: const Center(child: Icon(Icons.close,color: Colors.red,size: 15,)),
            ),
          ),
        ),
      ],
    ),
  );
 }

String formatTime(Duration duration){
  String twoDigits(int n) => n.toString().padLeft(2,'0');
  final hours = twoDigits(duration.inHours);
  final minutes =  twoDigits(duration.inMinutes.remainder(60));
  final seconds =  twoDigits(duration.inSeconds.remainder(60));

  return [
    if(duration.inHours > 0) hours,minutes,seconds].join(':');
}

void settingModalBottomSheet(context,
    {required VoidCallback onImageTap,
      required VoidCallback onMusicTap,
      required VoidCallback onVideoTap}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Images'),
                onTap: onImageTap),

            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video'),
              onTap: onVideoTap,
            ),
            ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Audio Recording'),
                onTap: onMusicTap),
          ],
        );
      });
}

void imagesModalBottomSheet(context, {required VoidCallback onCameraTap,required VoidCallback onGalleryTap}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Camera'),
                onTap: onCameraTap),
            ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Gallery'),
                onTap: onGalleryTap),
          ],
        );
      });
}




