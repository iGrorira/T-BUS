import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/user/detail/news_detail.dart';

class NewsPromotionUser extends StatelessWidget {
  const NewsPromotionUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 215, 253),
      appBar: AppBar(
        title: Text(
          "ข่าวสาร โปรโมชั่น",
          style: GoogleFonts.baiJamjuree(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("NewsAndPromotion")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsPromotionDetail(
                                  listNews: data,
                                ))),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color.fromARGB(255, 0, 31, 84)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: CachedNetworkImage(
                            imageUrl: data["imageUrlNews"],
                            height: 150,
                            width: 90,
                            fit: BoxFit.cover,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                        title: Text(
                          data["Topic"],
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["Detail"],
                              maxLines: 2,
                              style: GoogleFonts.baiJamjuree(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            const Divider(
                              color: Colors.black45,
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            ),
                            Text(
                              data["time"],
                              maxLines: 1,
                              style: GoogleFonts.baiJamjuree(
                                  fontSize: 13, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {}
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
