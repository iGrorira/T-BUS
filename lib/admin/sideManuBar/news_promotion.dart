import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/add_edit/add_edit_news_promotion.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/user/detail/news_detail.dart';

class newsPromotion extends StatelessWidget {
  const newsPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 175, 205, 249),
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

                  return Row(
                    children: [
                      Expanded(
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
                                  width: 1,
                                  color: Color.fromARGB(255, 0, 31, 84)),
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
                                    color: Colors.black54,
                                    thickness: 1,
                                    indent: 2,
                                    endIndent: 2,
                                  ),
                                  Text(
                                    data["time"],
                                    maxLines: 1,
                                    style: GoogleFonts.baiJamjuree(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            final newsPromotion = newsAndPromotion_model(
                              id: data.id,
                              Topic: data["Topic"],
                              Detail: data["Detail"],
                              imageUrlNews: data["imageUrlNews"],
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => addEditNewPromotion(
                                          newsPromotion: newsPromotion,
                                          index: index,
                                        ))));
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ลบข้อมูล?'),
                                    content: const Text(
                                        'คุณแน่ใจหรือว่าต้องการลบรายการนี้หรือไม่?'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('ยกเลิก'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          newsPromotion_controller()
                                              .detele_newsPromotion(
                                                  newsAndPromotion_model(
                                                      id: data.id));
                                        },
                                        child: const Text(
                                          'ลบ',
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  );
                });
          } else {}
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const addEditNewPromotion())),
        label: const Text('เพิ่มข่าวสารโปรโมชั่น'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[300],
      ),
    );
  }
}
