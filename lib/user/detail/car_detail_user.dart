import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';

// ignore: camel_case_types
class carDetailUser extends StatefulWidget {
  final DocumentSnapshot listCar;
  const carDetailUser({
    super.key,
    required this.listCar,
  });

  @override
  State<carDetailUser> createState() => _carDetailUserState();
}

// ignore: camel_case_types
class _carDetailUserState extends State<carDetailUser> {
  //เช็ค User
  bool _isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
    calculateAverage();
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

  //ดึงรีวิวรวมทั้งหมด
  double average = 0.0;
  Future<void> calculateAverage() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ReviweUser')
        .doc(widget.listCar.id)
        .collection("Reviwe")
        .get();

    int total = 0;
    int numberOfDocs = snapshot.docs.length;

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      total += doc['rating'] as int;
    }

    double avg = numberOfDocs > 0 ? total / numberOfDocs : 0;

    setState(() {
      average = avg;
    });
  }

  fetchReviewAll() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ReviweUser')
          .doc(widget.listCar.id)
          .collection("Reviwe")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // หรือ Widget ที่แสดงในระหว่างโหลดข้อมูล
        }*/

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("คะแนน", style: Textstyle().text18),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: 0.0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '( 0 ความคิดเห็น )',
                    style: Textstyle().text20,
                  ),
                ],
              ),
            ],
          );
        }

        // นับจำนวน doc.id ที่ถูกส่งกลับมาจาก Firebase
        int numberOfDocs = snapshot.data!.docs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("คะแนน", style: Textstyle().text18),
            Row(
              children: [
                RatingBarIndicator(
                  rating: average,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 24.0,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '( $numberOfDocs ความคิดเห็น )',
                  style: Textstyle().text20,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ดึงรีวิวแต่ละอัน
  fetchReview() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ReviweUser')
          .doc(widget.listCar.id)
          .collection("Reviwe")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }*/

        if (!snapshot.hasData || snapshot.data == null) {
          return Row(
            children: [
              Text(
                'ไม่มีข้อมูลรีวิว',
                style: Textstyle().text18,
              ),
            ],
          );
        }

        // ดึงข้อมูลจาก Sub Collection
        final List<DocumentSnapshot> subCollectionData = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: subCollectionData.length,
          itemBuilder: (context, index) {
            // ค่า rating ที่ได้จาก Firestore
            double rating =
                (subCollectionData[index]['rating'] ?? 0).toDouble();
            String eMail = subCollectionData[index]['Email'];

            // ตัวอย่างแสดงข้อมูลใน ListTile พร้อมดาว
            return Card(
              margin: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                    width: 1, color: Color.fromARGB(255, 0, 31, 84)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eMail,
                      style: Textstyle().text18,
                    ),
                    RatingBarIndicator(
                      rating: rating,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCollectionData[index]['review'],
                      style: Textstyle().text16,
                    ),
                    Text(
                      subCollectionData[index]['timestamp'],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //กดถูกใจ
  Future<void> toggleFavourite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("UsersFavouriteCar");

    final snapshot = await collectionRef
        .doc(currentUser!.email)
        .collection("Car")
        .where("NameTour", isEqualTo: widget.listCar['NameTour'])
        .where("Origin", isEqualTo: widget.listCar["Origin"])
        .where("Destination", isEqualTo: widget.listCar["Destination"])
        .where("Price", isEqualTo: widget.listCar["Price"])
        .where("DepartureTime", isEqualTo: widget.listCar["DepartureTime"])
        .where("TimetoArrive", isEqualTo: widget.listCar["TimetoArrive"])
        .where("PickUp", isEqualTo: widget.listCar["PickUp"])
        .where("DropOff", isEqualTo: widget.listCar["DropOff"])
        .where("TypeofCar", isEqualTo: widget.listCar["TypeofCar"])
        .where("imageUrlCar", isEqualTo: widget.listCar["imageUrlCar"])
        .where("RestStop", isEqualTo: widget.listCar["RestStop"])
        .where("service", isEqualTo: widget.listCar["service"])
        .where("round", isEqualTo: widget.listCar["round"])
        .get();

    if (snapshot.docs.isEmpty) {
      // The item doesn't exist in the favorites, add it.
      await collectionRef
          .doc(currentUser.email)
          .collection("Car")
          .doc(widget.listCar.id)
          .set({
        "NameTour": widget.listCar["NameTour"],
        "Origin": widget.listCar["Origin"],
        "Destination": widget.listCar["Destination"],
        "Price": widget.listCar["Price"],
        "DepartureTime": widget.listCar["DepartureTime"],
        "TimetoArrive": widget.listCar["TimetoArrive"],
        "PickUp": widget.listCar["PickUp"],
        "DropOff": widget.listCar["DropOff"],
        "TypeofCar": widget.listCar["TypeofCar"],
        "imageUrlCar": widget.listCar["imageUrlCar"],
        "RestStop": widget.listCar["RestStop"],
        "service": widget.listCar["service"],
        "round": widget.listCar["round"],
      });
    } else {
      // The item already exists in the favorites, remove it.
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  //เช็คการเข้าสู่ระบบเพื่อกดถูกใจ
  List<Widget> _buildAppBarActions() {
    if (_isAuthenticated) {
      // Actions for authenticated users
      return [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("UsersFavouriteCar")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("Car")
              .where("NameTour", isEqualTo: widget.listCar['NameTour'])
              .where("Origin", isEqualTo: widget.listCar["Origin"])
              .where("Destination", isEqualTo: widget.listCar["Destination"])
              .where("Price", isEqualTo: widget.listCar["Price"])
              .where("DepartureTime",
                  isEqualTo: widget.listCar["DepartureTime"])
              .where("TimetoArrive", isEqualTo: widget.listCar["TimetoArrive"])
              .where("PickUp", isEqualTo: widget.listCar["PickUp"])
              .where("DropOff", isEqualTo: widget.listCar["DropOff"])
              .where("TypeofCar", isEqualTo: widget.listCar["TypeofCar"])
              .where("imageUrlCar", isEqualTo: widget.listCar["imageUrlCar"])
              .where("RestStop", isEqualTo: widget.listCar["RestStop"])
              .where("service", isEqualTo: widget.listCar["service"])
              .where("round", isEqualTo: widget.listCar["round"])
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Text("");
            }
            return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: toggleFavourite,
                  icon: snapshot.data.docs.isEmpty
                      ? const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                ));
          },
        ),
      ];
    } else {
      // Actions for non-authenticated users
      return [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'คุณต้องการเข้าสู่ระบบหรือไม่?',
                    style: Textstyle().text18,
                  ),
                  content: Text(
                    'กดตกลงเพื่อเข้าสู่ระบบ',
                    style: Textstyle().text16,
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false);
                      },
                      child: const Text(
                        'ตกลง',
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.favorite_outline,
            color: Colors.white,
          ),
        ),
      ];
    }
  }

  final reviewfromUser = TextEditingController();
  int _rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 231, 252),
      appBar: AppBar(
        title: Text('รายละเอียดเพิ่มเติม', style: Textstyle().textTitleAppbar),
        actions: _buildAppBarActions(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: widget.listCar["imageUrlCar"],
                    height: 250,
                    width: 250,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.image),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              tableDetail(),
              const SizedBox(height: 10),
              Text('เขียนรีวิว', style: Textstyle().text20),
              rate(),
              const SizedBox(height: 10),
              review(),
              const SizedBox(height: 10),
              button(),
              const SizedBox(height: 10),
              Text('คะแนนและความคิดเห็น', style: Textstyle().text20),
              const Divider(
                color: Colors.black,
              ),
              fetchReviewAll(),
              const Divider(
                color: Colors.black,
              ),
              Text('ความคิดเห็น', style: Textstyle().text18),
              fetchReview(),
            ],
          ),
        ),
      )),
    );
  }

  void _saveReviewToFirebase(
    int rating,
  ) {
    // เชื่อมต่อกับคอลเล็กชัน "reviews" ใน Firebase
    String time = DateFormat('dd MMMM 2566').format(DateTime.now());
    final idCar = widget.listCar.id;
    final CollectionReference reviewsRef =
        FirebaseFirestore.instance.collection('ReviweUser/$idCar/Reviwe');
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    if (currentUser == null) {
      // Navigate to the login page if the user is not authenticated
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'คุณต้องการเข้าสู่ระบบหรือไม่?',
              style: Textstyle().text18,
            ),
            content: Text(
              'กดตกลงเพื่อเข้าสู่ระบบ',
              style: Textstyle().text16,
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false);
                },
                child: const Text(
                  'ตกลง',
                ),
              ),
            ],
          );
        },
      );
      return; // Stop further execution of the method
    }

    // เพิ่มเอกสารใหม่ (หากต้องการอัปเดตคะแนนรีวิวในเอกสารที่มีอยู่แล้วให้ใช้ .update() แทน)
    reviewsRef.doc().set({
      'Email': currentUser.email,
      'rating': rating,
      'review': reviewfromUser.text,
      'timestamp': time,
    }).then((value) {
      Fluttertoast.showToast(msg: 'รีวิวเสร็จเรียบร้อบ');
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'เกิดข้อผิดพลาดในการบันทึกคะแนนรีวิว: $error');
    });
    setState(() {
      rating = 0; // ลบค่า rating
      reviewfromUser.clear(); // ลบค่า review
    });
  }

  Padding button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttomapp,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          _saveReviewToFirebase(_rating);
        },
        child: Center(
          child: Text(
            'รีวิว',
            style: GoogleFonts.baiJamjuree(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  Row rate() {
    return Row(
      children: [
        IconButton(
          icon: _rating >= 1
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
          onPressed: () => _setRating(1),
        ),
        IconButton(
          icon: _rating >= 2
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
          onPressed: () => _setRating(2),
        ),
        IconButton(
          icon: _rating >= 3
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
          onPressed: () => _setRating(3),
        ),
        IconButton(
          icon: _rating >= 4
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
          onPressed: () => _setRating(4),
        ),
        IconButton(
          icon: _rating >= 5
              ? const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
          onPressed: () => _setRating(5),
        ),
      ],
    );
  }

  Padding review() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
        maxLength: 150,
        keyboardType: TextInputType.text,
        controller: reviewfromUser,
        decoration: InputDecoration(
          labelText: 'ความคิดเห็น',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
      ),
    );
  }

  Table tableDetail() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(3),
      },
      /*border: const TableBorder(
                bottom: BorderSide(color: Colors.black38, width: 2),
                horizontalInside: BorderSide(color: Colors.black38, width: 2),
              ),*/
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "บริษัท :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['NameTour'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "รอบ : ",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['round'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "รถออกเวลา :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['DepartureTime'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "รถถึงเวลา :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['TimetoArrive'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "ต้นทาง :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['Origin'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "จุดขึ้นรถ :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['PickUp'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "ปลายทาง :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['Destination'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "จุดลงรถ :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['DropOff'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "ราคา :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "${widget.listCar['Price']} บาท",
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "ประเภทรถ :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['TypeofCar'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "บริการ :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['service'],
              style: Textstyle().text20,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "จุดพักรถ :",
              style: Textstyle().text20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.listCar['RestStop'],
              style: Textstyle().text20,
            ),
          ),
        ]),
      ],
    );
  }
}
