import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:picsumpphotos/photo.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final Photo photo;

  const DetailsPage({super.key, required this.photo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.photo.author}'),
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: '${widget.photo.downloadUrl}',
          ),
          SizedBox(
            height: 50,
          ),
          // SizedBox(
          //   height: 30,
          // ),
          ElevatedButton(
            onPressed: () async {
              launchUrl(Uri.parse('${widget.photo.url}'));
            },
            child: Text('Show',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    );
  }
}
