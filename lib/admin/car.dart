import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/add_car.dart';

class CarAdmin extends StatefulWidget {
  const CarAdmin({Key? key}) : super(key: key);

  @override
  State<CarAdmin> createState() => _CarAdminState();
}

class _CarAdminState extends State<CarAdmin> {
  final _firestoreInstance = FirebaseFirestore.instance;
  final List _cars = [];

  fetchCars() async {
    QuerySnapshot qn = await _firestoreInstance.collection("list").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _cars.add({
          "NameTour": qn.docs[i]["NameTour"],
          "Keyword": qn.docs[i]["Keyword"],
          "Price": qn.docs[i]["Price"],
          "DepartureTime": qn.docs[i]["DepartureTime"],
          "TimetoArrive": qn.docs[i]["TimetoArrive"],
          "PickUp": qn.docs[i]["PickUp"],
          "DropOff": qn.docs[i]["DropOff"],
          "TypeofCar": qn.docs[i]["TypeofCar"],
          "Origin": qn.docs[i]["Origin"],
          "Destination": qn.docs[i]["Destination"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เที่ยวรถทัวร์"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AddCar())),
              icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _cars.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                        "${_cars[index]["DepartureTime"]}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${_cars[index]["Origin"]}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${_cars[index]["NameTour"]}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Icon(
                                        Icons.directions_bus,
                                        color: Colors.blue,
                                      ),
                                      Text("${_cars[index]["TypeofCar"]}"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${_cars[index]["TimetoArrive"]}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${_cars[index]["DropOff"]}",
                                        style: const TextStyle(fontSize: 20),
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
                                  const Text("รายละเอียดเพิ่มเติม"),
                                  Text(
                                    "${_cars[index]["Price"]}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
