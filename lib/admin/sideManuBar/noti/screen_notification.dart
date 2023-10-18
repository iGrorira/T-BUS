import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';

class ScreenNotification extends StatefulWidget {
  final String topic;
  final String imageUrlNews;
  final String detail;
  final String time;
  const ScreenNotification(
      {super.key,
      required this.topic,
      required this.imageUrlNews,
      required this.detail,
      required this.time});

  @override
  State<ScreenNotification> createState() => _ScreenNotificationState();
}

class _ScreenNotificationState extends State<ScreenNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic)),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color.fromARGB(255, 5, 31, 77),
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  Text(
                    widget.topic,
                    style: GoogleFonts.baiJamjuree(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrlNews,
                        height: 270,
                        width: 370,
                        fit: BoxFit.cover,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.detail,
                    style: Textstyle().text18,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*const Icon(
                        Icons.access_time,
                        size: 16,
                      ),*/
                      Text(
                        //"${data['Price']} บาท"
                        //"สร้างเมื่อวันที่ ${widget.listNews['time']}",
                        widget.time,
                        style: Textstyle().text16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
