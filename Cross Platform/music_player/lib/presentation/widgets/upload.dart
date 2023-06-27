import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/constants/strings.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  Uint8List? imageBytes;
  String imageName = 'No image choosen';
  Uint8List? musicBytes;
  String musicName = 'No audio file choosen';
  File? imgProfile;
  final musicController = TextEditingController();
  final creatorController = TextEditingController();

  Future pickImage() async {
    try {
      final imagePicker =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagePicker == null) return;
      imageBytes = await imagePicker.readAsBytes();
      setState(() {
        imageName = imagePicker.name;
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    final fileBytes = result.files.single.bytes;
    if (fileBytes == null) {
      return;
    }
    setState(() {
      musicName = result.files.single.name;
    });
    musicBytes = fileBytes;
  }

  void submit() {
    BlocProvider.of<MusicCubit>(context).upload(
        musicController.text, creatorController.text, imageBytes, musicBytes);
  }

  Widget uploadBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Upload Music",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[800],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageName == 'No image choosen'
                          ? const Icon(Icons.person)
                          : Image.memory(
                              imageBytes!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('  $imageName'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => pickImage(),
                    child: const Text('Choose Image'),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: musicController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Music title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: creatorController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Music creator',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => pickFile(),
                        child: const Text('Choose Audio File'),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 230,
                        child: Text(
                          '  $musicName',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<MusicCubit, MusicState>(
            builder: (context, state) {
              if (state is UploadFailed) {
                return Text(state.errorMessage,
                    style: const TextStyle(fontSize: 17, color: Colors.red));
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 120,
            height: 36,
            child: ElevatedButton(
              onPressed: () => submit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: BlocBuilder<MusicCubit, MusicState>(
                builder: (context, state) {
                  if (state is UploadLoading) {
                    return const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  }

                  return const Text('Submit', style: TextStyle(fontSize: 19));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicCubit, MusicState>(
      listener: (context, state) {
        if (state is UploadSuccess) {
          Navigator.pushReplacementNamed(context, homePageRoute);
        }
      },
      child: uploadBody(),
    );
  }
}
