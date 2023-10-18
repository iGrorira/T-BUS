// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:runnn/user/detail/car_detail_user.dart';
import 'package:runnn/user/filter/filter_car.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  int count = 1;
  String timeDoc = DateFormat('dd_M_2566').format(DateTime.now());

  String input = "";
  List<String> searchHistory = [];
  bool isSearchHistoryVisible = false;
  void addToSearchHistory(String keyword) {
    if (!searchHistory.contains(keyword)) {
      setState(() {
        searchHistory.add(keyword);
      });
    }
  }

  Future<void> addHistory(data) async {
    final Timestamp timestamp = Timestamp.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("UsersHistory");

    await collectionRef
        .doc(currentUser?.email)
        .collection("HistoryCar")
        .doc(data.id)
        .set({
      "NameTour": data["NameTour"],
      "Origin": data["Origin"],
      "Destination": data["Destination"],
      "Price": data["Price"],
      "DepartureTime": data["DepartureTime"],
      "TimetoArrive": data["TimetoArrive"],
      "PickUp": data["PickUp"],
      "DropOff": data["DropOff"],
      "TypeofCar": data["TypeofCar"],
      "imageUrlCar": data["imageUrlCar"],
      "RestStop": data["RestStop"],
      "service": data["service"],
      "round": data["round"],
      'timestamp': timestamp,
    });
  }

  //เช็ค User
  bool _isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 119, 230),
        title: CupertinoSearchTextField(
          placeholder: 'ค้นหาที่นี่...',
          style: GoogleFonts.baiJamjuree(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {
              input = value;
            });
          },
          onTap: () {
            setState(() {
              isSearchHistoryVisible = true;
            });
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          tooltip: 'ตัวกรอง',
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FilterCar()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'ค้นหา',
            onPressed: () {
              setState(() {
                addToSearchHistory(input);
                isSearchHistoryVisible = false; // กดค้นหาให้ซ่อนประวัติการค้นหา
              });
            },
          ),
        ],
      ),

      /**
       if (isSearchHistoryVisible)
              ListView.builder(
                shrinkWrap: true,
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  final keyword = searchHistory[index];
                  return ListTile(
                    title: Text(keyword),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          searchHistory.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                    onTap: () {
                      setState(() {
                        input = keyword;
                        isSearchHistoryVisible = false;
                      });
                    },
                  );
                },
              ),
       */
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("ListCar").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    final routeOrigin = data['Origin'];
                    final routeDestination = data['Destination'];
                    final sumRoute = '${routeOrigin}_$routeDestination';
                    final routeTour = '$routeOrigin - $routeDestination';
                    if (input.isEmpty) {
                      return inputEmpty(data, context);
                    }
                    if (data['Keyword']
                        .toString()
                        .toLowerCase()
                        .startsWith(input.toLowerCase())) {
                      return inputKeyword(data, context, sumRoute, routeTour);
                    }
                    if (data['NameTour']
                        .toString()
                        .toLowerCase()
                        .startsWith(input.toLowerCase())) {
                      return inputNameTour(data, context);
                    }

                    return Container();
                  },
                );
        },
      ),
    );
  }

  Padding inputNameTour(DocumentSnapshot<Object?> data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Set border width
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ), // Set rounded corner radius
          boxShadow: const [
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      data['DepartureTime'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Origin'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2),
                    Text(
                      data['NameTour'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                    ),
                    Text(
                      data['TypeofCar'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      data['TimetoArrive'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Destination'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.black38,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                carDetailUser(listCar: data)));
                    final countRouteMostRef = FirebaseFirestore.instance
                        .collection("CountCompanyMost")
                        .doc(timeDoc)
                        .collection('Company')
                        .doc(data['NameTour']);

                    final existingData = await countRouteMostRef.get();

                    if (existingData.exists) {
                      // กรณีมีข้อมูลอยู่แล้ว
                      final existingCount = existingData.data()?['count'] ?? 0;
                      count = existingCount +
                          1; // เพิ่มค่า count เมื่อเก็บข้อมูลต่อเนื่อง
                    } else {
                      // กรณียังไม่มีข้อมูล
                      count =
                          1; // เริ่มนับใหม่เมื่อเก็บข้อมูลลงคอลเลกชันที่ยังไม่มีข้อมูล
                    }

                    await countRouteMostRef.set({
                      "count": count,
                      "NameTour": data['NameTour'].toString(),
                    });
                  },
                  child: Text(
                    "รายละเอียดเพิ่มเติม",
                    style: GoogleFonts.baiJamjuree(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 93, 176, 244)),
                  ),
                ),
                Text(
                  "${data['Price']} บาท",
                  style: GoogleFonts.baiJamjuree(
                      fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding inputKeyword(DocumentSnapshot<Object?> data, BuildContext context,
      String sumRoute, String routeTour) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Set border width
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ), // Set rounded corner radius
          boxShadow: const [
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      data['DepartureTime'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Origin'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2),
                    Text(
                      data['NameTour'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                    ),
                    Text(
                      data['TypeofCar'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      data['TimetoArrive'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Destination'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.black38,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                carDetailUser(listCar: data)));
                    final countRouteMostRef = FirebaseFirestore.instance
                        .collection("CountRouteMost")
                        .doc(timeDoc)
                        .collection('Route')
                        .doc(sumRoute);

                    final existingData = await countRouteMostRef.get();

                    if (existingData.exists) {
                      // กรณีมีข้อมูลอยู่แล้ว
                      final existingCount = existingData.data()?['count'] ?? 0;
                      count = existingCount +
                          1; // เพิ่มค่า count เมื่อเก็บข้อมูลต่อเนื่อง
                    } else {
                      // กรณียังไม่มีข้อมูล
                      count =
                          1; // เริ่มนับใหม่เมื่อเก็บข้อมูลลงคอลเลกชันที่ยังไม่มีข้อมูล
                    }

                    await countRouteMostRef.set({
                      "count": count,
                      "routeTour": routeTour,
                    });
                  },
                  child: Text(
                    "รายละเอียดเพิ่มเติม",
                    style: GoogleFonts.baiJamjuree(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 93, 176, 244)),
                  ),
                ),
                Text(
                  "${data['Price']} บาท",
                  style: GoogleFonts.baiJamjuree(
                      fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding inputEmpty(DocumentSnapshot<Object?> data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Set border width
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ), // Set rounded corner radius

          boxShadow: const [
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      data['DepartureTime'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Origin'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2),
                    Text(
                      data['NameTour'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                    ),
                    Text(
                      data['TypeofCar'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      data['TimetoArrive'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      data['Destination'],
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.black38,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isAuthenticated) addHistory(data);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => carDetailUser(listCar: data),
                        ));
                  },
                  child: Text(
                    "รายละเอียดเพิ่มเติม",
                    style: GoogleFonts.baiJamjuree(
                        fontSize: 18, color: Color.fromARGB(255, 93, 176, 244)),
                  ),
                ),
                Text(
                  "${data['Price']} บาท",
                  style: GoogleFonts.baiJamjuree(
                      fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
