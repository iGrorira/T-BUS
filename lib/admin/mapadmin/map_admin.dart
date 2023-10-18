import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/mapadmin/add_edit_map.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appcolors.dart';

class MapAdmid extends StatefulWidget {
  const MapAdmid({super.key});

  @override
  State<MapAdmid> createState() => _MapAdmidState();
}

class _MapAdmidState extends State<MapAdmid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Locations").snapshots(),
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

                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: Color.fromARGB(255, 0, 31, 84)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        "${data["name"]}",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            maxLines: 1,
                            "ละติจูด ${data["latitude"]} ,",
                            style: Textstyle().text16,
                          ),
                          Text(
                            "ลองติจูด ${data['longitude']}",
                            maxLines: 1,
                            style: Textstyle().text16,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final map = mapLocation_model(
                                  id: data.id,
                                  latitude: data["latitude"],
                                  longitude: data["longitude"],
                                  name: data["name"],
                                  address: data["address"],
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => AddEditMap(
                                              map: map,
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
                                              map_controller().detele_map(
                                                  mapLocation_model(
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
                      ),
                    ),
                  );
                });
          } else {}
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddEditMap())),
        label: const Text('เพิ่มเพิ่มบริษัททัวร์'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[300],
      ),
    );
  }
}
