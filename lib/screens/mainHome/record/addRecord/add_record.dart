import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firestore_record/app_providers/authentication_provider.dart';
import 'package:firestore_record/app_providers/record_provider.dart';
import 'package:firestore_record/core/common/app_utility.dart';
import 'package:firestore_record/dependency_injection.dart';
import 'package:firestore_record/route/routeString.dart';
import 'package:firestore_record/screens/mainHome/record/video_screen.dart';
import 'package:firestore_record/source/model/add_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:audioplayers/audioplayers.dart';
import '../home/detailsScreen/imageViewScreen.dart';
import '../signin/sign_in_widgets/sign_in-widget.dart';
import '../widgets/process_loading_light.dart';
import '../widgets/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:path_provider/path_provider.dart' as path_provider;

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  TextEditingController nameController =
      TextEditingController(text: 'kmkmkmkmkm');
  TextEditingController phoneController =
      TextEditingController(text: '9999999999');
  TextEditingController aboutMeController =
      TextEditingController(text: 'kmkmkmkmkm');
  TextEditingController dateController =
      TextEditingController(text: 'kmkmkmkmkm');
  TextEditingController timeController =
      TextEditingController(text: 'kmkmkmkmkm');
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  File galleryVideoFile = File("");
  final picker = ImagePicker();
  final List<File> _addImageList = [];
  final List<File> _videoPathList = [];
  final List<File> _videoThumbNailList = [];
  final List<XFile> _compressedFile = [];

  Uint8List? _thumbnail;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  CountryCode countryCode =
      CountryCode(name: "Pakistan", code: "Pk", dialCode: "+92");
  final _formKey = GlobalKey<FormState>();
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;

  final recordProvider = sl<RecordProvider>();
  final authProvider = sl<AuthenticationProvider>();

  ///date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("MMMM dd, yyyy").format(selectedDate);
      });
    }
  }

  ///time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });
    final localization = MaterialLocalizations.of(context);

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = localization.formatTimeOfDay(selectedTime);
      });
    }
  }

  void _onCountryChange(CountryCode code) {
    setState(() {
      countryCode = code;
    });
  }

  void _onAddRecordPressed() async {
    if (!_formKey.currentState!.validate()) return;
    final List<String> imageResponseList = [];
    final List<String> videoResponseList = [];
    final List<String> thumbnailResponseList = [];

    for (var image in _addImageList) {
      await recordProvider.postImage(file: image);
      imageResponseList.add(recordProvider.uploadImage);
    }

    for (var thumbnail in _videoThumbNailList) {
      await recordProvider.postThumbnail(file: thumbnail);
      thumbnailResponseList.add(recordProvider.uploadThumbnail);
    }
    for (var videoUrl in _videoPathList) {
      await recordProvider.postVideo(file: videoUrl);
      videoResponseList.add(recordProvider.uploadVideo);
    }

    await recordProvider.addUserRecord(context,
        userId: authProvider.getUserUId.toString(),
        addRecordModel: AddRecordModel(
          name: nameController.text.trim(),
          code: countryCode.dialCode,
          about: aboutMeController.text.trim(),
          number: phoneController.text.trim(),
          date: dateController.text.trim(),
          time: timeController.text.trim(),
          audioPath: recordProvider.audioPath,
          img: imageResponseList,
          video: videoResponseList,
          thumbnail: thumbnailResponseList,
        ));
  }

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
    TextStyle fieldTitle = const TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
    TextStyle buttonStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
    TextStyle red = const TextStyle(
        fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500);
    return Consumer<RecordProvider>(builder: (context, recordState, child) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo.shade400,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: const Text(
                "Add Records",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///name
                        ...[
                          Text("Name", style: fieldTitle),
                          customTextField(
                              onValidator: (value) => AppUtility.validateName(
                                  context, value?.trim(), 'Please enter name'),
                              controller: nameController,
                              hintText: "Enter you name"),
                        ],

                        ///phone
                        ...[
                          Text("Phone", style: fieldTitle),
                          customTextField(
                              controller: phoneController,
                              comingFrom: 'password',
                              prefix: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                                child: Container(
                                  height: 45,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      // color: Colors.red,
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.grey.shade400)),
                                  child: CountryCodePicker(
                                    padding: const EdgeInsets.all(0),
                                    initialSelection: countryCode.dialCode,
                                    onChanged: _onCountryChange,
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              onValidator: (value) => AppUtility.validateNumber(
                                  context,
                                  value?.trim(),
                                  'Please enter phone number'),
                              hintText: "Enter you phone number"),
                        ],

                        ///about
                        ...[
                          Text("About Me", style: fieldTitle),
                          customTextField(
                              controller: aboutMeController,
                              onValidator: (value) => AppUtility.validateName(
                                  context,
                                  value?.trim(),
                                  'Please enter description'),
                              hintText: "Enter you description"),
                        ],

                        ///date
                        ...[
                          Text("Date", style: fieldTitle),
                          customTextField(
                              controller: dateController,
                              readOnly: true,
                              hintText: "Enter the date",
                              onValidator: (value) => AppUtility.validateName(
                                  context, value?.trim(), 'Please select date'),
                              icon: Icons.calendar_month_sharp,
                              onTap: () {
                                _selectDate(context);
                              }),
                        ],

                        ///time
                        ...[
                          Text("Time", style: fieldTitle),
                          customTextField(
                              controller: timeController,
                              readOnly: true,
                              hintText: "Enter the time",
                              onValidator: (value) => AppUtility.validateName(
                                  context, value?.trim(), 'Please select time'),
                              icon: Icons.access_time,
                              onTap: () {
                                _selectTime(context);
                              }),
                        ],

                        ///images
                        ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Images", style: fieldTitle),
                                GestureDetector(
                                  onTap: () {
                                    settingModalBottomSheet(context,
                                        onImageTap: () {
                                      imagesModalBottomSheet(context,
                                          onCameraTap: () {
                                        getCameraImage();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }, onGalleryTap: () {
                                        getGalleryImage();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    }, onMusicTap: () {
                                      audioPlayer.pause();
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, RouteString.audioRoute);
                                    }, onVideoTap: () {
                                      _videoModalBottomSheet(context);
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade400,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text("Upload Images",
                                              style: fieldTitle.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12)))),
                                )
                              ],
                            ),
                          ),

                          ///image listview
                          _addImageList.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    "No Images added",
                                    style: red,
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: SizedBox(
                                    height: 70,
                                    width: double.infinity,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _addImageList.length,
                                        itemBuilder: (context, index) {
                                          final image = _addImageList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ImageViewScreen()));
                                            },
                                            child: list(
                                                image: image,
                                                onRemoveListTap: () {
                                                  setState(() {
                                                    _addImageList.remove(image);
                                                  });
                                                }),
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
                                Text("Videos", style: fieldTitle),
                              ],
                            ),
                          ),

                          ///video listview
                          _videoThumbNailList.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    "No Videos added",
                                    style: red,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: SizedBox(
                                    height: 60,
                                    width: double.infinity,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _videoThumbNailList.length,
                                        itemBuilder: (context, index) {
                                          final video =
                                              _videoThumbNailList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoScreen(
                                                            videoUrl:
                                                                _videoPathList[
                                                                        index]
                                                                    .path,
                                                          )));
                                            },
                                            child: list(
                                              comingFrom: "",
                                              image: video,
                                              onRemoveListTap: () {
                                                setState(() {
                                                  _videoThumbNailList
                                                      .remove(video);
                                                });
                                              },
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
                                Text("Audio", style: fieldTitle),
                              ],
                            ),
                          ),

                          /// recorded audio
                          recordProvider.audioPath.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: IconButton(
                                            onPressed: () {
                                              if (isPlaying) {
                                                audioPlayer.pause();
                                              } else {
                                                audioPlayer.play(UrlSource(
                                                    recordProvider.audioPath));
                                              }
                                            },
                                            icon: Icon(isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Slider(
                                                min: 0,
                                                max: duration.inSeconds
                                                    .toDouble(),
                                                value: position.inSeconds
                                                    .toDouble(),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                  Text(formatTime(
                                                      duration - position)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    "No Audio Added",
                                    style: red,
                                  ),
                                ),
                        ],

                        ///button
                        ...[
                          const SizedBox(
                            height: 40,
                          ),
                          button(buttonStyle, Colors.indigo.shade500, "Upload",
                              () {
                            _onAddRecordPressed();
                            // Navigator.pop(context);
                          }),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (recordState.addRecordStatus == RecordStatus.loading ||
              recordState.postImageStatus == RecordStatus.loading)
            const ProcessLoadingLight()
        ],
      );
    });
  }

  Future getCameraImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100);
      if (pickedFile == null) return;
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecond}.${pickedFile!.path.split(".").last}";
      final result = await FlutterImageCompress.compressAndGetFile(
          pickedFile!.path, targetPath,
          quality: 50, minHeight: 500, minWidth: 500);

      setState(() {
        if (result != null) {
          _selectedImage = File(result.path);
          _addImageList.add(_selectedImage!);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getGalleryImage() async {
    try {
      _compressedFile.clear();

      final pickedFile = await _picker.pickMultiImage(
          imageQuality: 100, maxHeight: 1000, maxWidth: 1000);

      for (var image in pickedFile) {
        final dir = await path_provider.getTemporaryDirectory();
        final targetPath =
            "${dir.absolute.path}/${DateTime.now().millisecond}.${image!.path.split(".").last}";
        final result = await FlutterImageCompress.compressAndGetFile(
            image!.path, targetPath,
            quality: 50, minHeight: 500, minWidth: 500);
        _compressedFile.add(result!);
      }
      List<XFile> multiImage = _compressedFile;

      setState(() {
        if (multiImage != null) {
          for (var i = 0; i < multiImage.length; i++) {
            _addImageList.add(File(multiImage[i].path));
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _videoModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Camera'),
                  onTap: () => {
                        getVideo(ImageSource.camera),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }),
              ListTile(
                  leading: const Icon(Icons.music_note),
                  title: const Text('Gallery'),
                  onTap: () => {
                        getVideo(ImageSource.gallery),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }),
            ],
          );
        });
  }

  Future<void> _generateThumbNail(String videoPath) async {
    final uInt8List = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
    );
    setState(() {
      _videoThumbNailList.add(File(uInt8List!));
    });
  }

  Future getVideo(ImageSource img) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    setState(
      () {
        if (pickedFile != null) {
          galleryVideoFile = File(pickedFile!.path);
            _videoPathList.add(galleryVideoFile!);
          _generateThumbNail(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
