import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firestore_record/app_providers/record_provider.dart';
import 'package:firestore_record/source/model/add_record.dart';
import 'package:flutter/material.dart';
import '../../../../../dependency_injection.dart';
import '../../video_screen.dart';
import '../../widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import 'imageViewScreen.dart';

class RecordDetailScreen extends StatefulWidget {
  AddRecordModel addRecordModel;
   RecordDetailScreen({super.key,required this.addRecordModel});

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  double bottom = 15;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final recordProvider = sl<RecordProvider>();


  @override
  void initState() {

     /// Listen to state : playing,pause,stopped
     audioPlayer.onPlayerStateChanged.listen((state) {
       setState(() {
         isPlaying = state == PlayerState.playing;
       });
     });
     /// Listen to audio duration
     audioPlayer.onDurationChanged.listen((newDuration) {
       setState(() {
         duration = newDuration;
       });
     });
     /// Listen to audio position
     audioPlayer.onPositionChanged.listen((newPosition) {
       setState(() {
         position = newPosition;
       });
     });



    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    TextStyle appTitle =  const TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white);
    TextStyle title =  const TextStyle(fontWeight: FontWeight.bold,fontSize: 16);
    TextStyle detail =  const TextStyle(fontWeight: FontWeight.w500,fontSize: 14);
    TextStyle red =  TextStyle(
        fontSize: 14, color: Colors.red.shade800, fontWeight: FontWeight.w500,);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo.shade400,
        title:  Text("Record Detail",style: appTitle),
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back,color: Colors.white,)),

        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              ///name
              ...[
                Padding(
                padding:  EdgeInsets.only(bottom: bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name:        ",style: title),
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        //color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.50,
                          child:  Text(widget.addRecordModel.name.toString(),style: detail,)),
                    ),
          
                  ],
                ),
              ),],
          
              ///date
              ...[
                Padding(
                padding:  EdgeInsets.only(bottom:bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date:          ",style: title),
                    Text(widget.addRecordModel.date.toString(),style: detail),
          
                  ],
                ),
              ),],
          
              ///time
              ...[
                Padding(
                padding:  EdgeInsets.only(bottom:bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time:          ",style: title),
                    Text(widget.addRecordModel.time.toString(),style: detail),
          
                  ],
                ),
              )],
          
              ///phone number
              ...[
                Padding(
                padding:  EdgeInsets.only(bottom:bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone \nNumber:    ",style: title),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${widget.addRecordModel.code.toString()} ",style: detail),
                        Text(widget.addRecordModel.number.toString(),style: detail),
                      ],
                    ),
          
                  ],
                ),
              ),],
          
              ///about me
             ...[
               Padding(
                padding:  EdgeInsets.only(bottom: bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About Me: ",style: title),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child:  Text(widget.addRecordModel.about.toString(),style: detail,)),
                    ),
          
                  ],
                ),
              ),],
          
              /// images
              ...[
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Images", style: title),

                  ],
                ),
              ),

              ///image listview
              widget.addRecordModel.img!.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "No images found",
                        style: red,
                      ),
                    )
                  :  Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.addRecordModel.img!.length,
                            itemBuilder: (context, index) {
                              final image = widget.addRecordModel.img![index];
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewScreen(
                                      detailImageList: widget.addRecordModel.img, )));
                                },
                                child: list(
                                  comingFromPage: 'detail',
                                    comingFrom: "image",
                                    networkImage: image,

                                    onRemoveListTap: () {
                                      setState(() {
                                        widget.addRecordModel.img!.remove(image);
                                      });
                                    }, ),
                              );
                            }),
                      ),
                    ),
              ],
          
              ///videos
             ...[
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Videos", style: title),
                  ],
                ),
              ),
          
              ///video listview


               widget.addRecordModel.thumbnail!.isEmpty
                   ? Padding(
                 padding:
                 const EdgeInsets.symmetric(vertical: 10.0),
                 child: Text(
                   "No videos found",
                   style: red,
                 ),
               )
                   : Padding(
                 padding:
                 const EdgeInsets.symmetric(vertical: 10.0),
                 child: SizedBox(
                   height: 60,
                   width: double.infinity,
                   child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount:  widget.addRecordModel.thumbnail!.length,
                       itemBuilder: (context, index) {
                         final thumbnail =  widget.addRecordModel.thumbnail![index];
                         return GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) =>  VideoScreen(videoUrl: widget.addRecordModel.video![index],)));
                           },
                           child: list(
                               comingFromPage: 'detail',
                               comingFrom: "image",
                               networkImage: thumbnail,


                               ),
                         );
                       }),
                 ),
               ),



          
             ],
          
             ///audio
              ...[
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Audio", style: title),
                  ],
                ),
              ),
              /// record audio
              widget.addRecordModel.audioPath!.isNotEmpty
              ? Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 25,
                      child: IconButton(
                          onPressed: () async{
                            if (isPlaying) {
                              audioPlayer.pause();
                            }
                            else {
                              await audioPlayer.play(UrlSource(widget.addRecordModel.audioPath.toString()));
                            }
          
                          },
                          icon: Icon(isPlaying
                              ? Icons.pause
                              : Icons.play_arrow)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Slider(
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() async {
                                  final position = Duration(
                                      seconds: value.toInt());
                                  await audioPlayer
                                      .seek(position);
          
                                  ///play audio if it was pause
                                  await audioPlayer.resume();
                                });
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(formatTime(position)),
                                Text(formatTime( duration - position)),
          
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : Text("No audio found",style: red),],
          
          
              const SizedBox(
                height: 40,
              ),
          
          
          
            ],
          ),
        ),
      ),
    );



  }
}


