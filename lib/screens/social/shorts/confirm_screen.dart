// // ignore_for_file: use_build_context_synchronously

// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// import 'package:health_app/provider/user_provider.dart';
// import 'package:health_app/resources/firestore_methods.dart';
// import 'package:health_app/screens/navBar.dart';
// import 'package:health_app/util/utils.dart';

// import 'package:health_app/widgets/shorts_text_field.dart';
// import 'package:provider/provider.dart';

// import 'package:video_player/video_player.dart';

// class ConfirmScreen extends StatefulWidget {
//   final Uint8List videoFile;
//   final String videoPath;
//   const ConfirmScreen({
//     Key? key,
//     required this.videoFile,
//     required this.videoPath,
//   }) : super(key: key);

//   @override
//   State<ConfirmScreen> createState() => _ConfirmScreenState();
// }

// class _ConfirmScreenState extends State<ConfirmScreen> {
//   late VideoPlayerController controller;
//   final TextEditingController _songController = TextEditingController();
//   final TextEditingController _captionController = TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       controller = VideoPlayerController.file(widget.videoFile);
//     });
//     controller.initialize();
//     controller.play();
//     controller.setVolume(1);
//     controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   void postVideo(
//     String uid,
//     String profilePhoto,
//     String username,
//   ) async {
//     setState(() {
//       isLoading = true;
//     });
//     // start the loading
//     try {
//       // upload to storage and db
//       String res = await FirestoreMethods().uploadVideo(
//           caption: _captionController.text,
//           profileImg: profilePhoto,
//           uid: uid,
//           username: username,
//           video: widget.videoFile,
//           songName: _songController.text);
//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });
//         showSnackBar(
//           'Posted!',
//           context,
//         );

//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return const ButtonNavBar();
//         }));
//       } else {
//         showSnackBar(
//           res,
//           context,
//         );
//       }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       showSnackBar(
//         err.toString(),
//         context,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider user = Provider.of<UserProvider>(context);
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 1.5,
//               child: VideoPlayer(controller),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     width: MediaQuery.of(context).size.width - 20,
//                     child: TextInputField(
//                       controller: _songController,
//                       labelText: 'Song Name',
//                       icon: Icons.music_note,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     width: MediaQuery.of(context).size.width - 20,
//                     child: TextInputField(
//                       controller: _captionController,
//                       labelText: 'Caption',
//                       icon: Icons.closed_caption,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                       onPressed: () => postVideo(
//                             user.getUser.profilePhoto!,
//                             user.getUser.uid,
//                             user.getUser.username,
//                           ),
//                       child: const Text(
//                         'Share!',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                       ))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
