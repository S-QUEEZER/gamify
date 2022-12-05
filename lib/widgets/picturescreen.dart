import 'package:flutter/material.dart';

class PictureScreen extends StatelessWidget {
  final String imageUrl;
  const PictureScreen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imageUrl))),
      ),
    );
  }
}
