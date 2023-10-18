import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/add_edit/add_edit_car.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/user/detail/car_detail_user.dart';

class CarAdmin extends StatelessWidget {
  const CarAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("ListCar").snapshots(),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              // Set border width

                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ), // Set rounded corner radius
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                  offset: Offset(1, 3),
                                ),
                              ], // Make rounded corner of border
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          data["DepartureTime"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          data["Origin"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          data["NameTour"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        const Icon(
                                          Icons.directions_bus,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          data["TypeofCar"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          data["TimetoArrive"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          data["Destination"],
                                          style: GoogleFonts.baiJamjuree(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black38,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    carDetailUser(
                                                        listCar: data)));
                                      },
                                      child: Text(
                                        "รายละเอียดเพิ่มเติม",
                                        style: GoogleFonts.baiJamjuree(
                                            fontSize: 20, color: Colors.blue),
                                      ),
                                    ),
                                    Text(
                                      //data["Price"],
                                      "${data['Price']} บาท",
                                      style: GoogleFonts.baiJamjuree(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              final car = car_model(
                                id: data.id,
                                NameTour: data['NameTour'],
                                Keyword: data['Keyword'],
                                Origin: data['Origin'],
                                Destination: data['Destination'],
                                Price: data['Price'],
                                DepartureTime: data['DepartureTime'],
                                TimetoArrive: data['TimetoArrive'],
                                PickUp: data['PickUp'],
                                DropOff: data['DropOff'],
                                TypeofCar: data['TypeofCar'],
                                imageUrlCar: data['imageUrlCar'],
                                service: data['service'],
                                RestStop: data['RestStop'],
                                round: data['round'],
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => addEditCar(
                                        car: car,
                                        index: index,
                                      )),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'ลบข้อมูล?',
                                        style: Textstyle().text20,
                                      ),
                                      content: Text(
                                        'คุณแน่ใจหรือว่าต้องการลบรายการนี้หรือไม่?',
                                        style: Textstyle().text18,
                                      ),
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
                                              car_controller().detele_car(
                                                  car_model(id: data.id));
                                            },
                                            child: const Text('ลบ')),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.delete))
                      ],
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
            context, MaterialPageRoute(builder: (_) => const addEditCar())),
        label: const Text('เพิ่มเที่ยวรถ'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[300],
      ),
    );
  }
}
