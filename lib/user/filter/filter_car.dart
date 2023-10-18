import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/user/filter/filter_car_result.dart';

class FilterCar extends StatefulWidget {
  const FilterCar({super.key});

  @override
  _FilterCarState createState() => _FilterCarState();
}

class _FilterCarState extends State<FilterCar> {
  final _formKey = GlobalKey<FormState>();

  String? fromValue;
  String? toValue;
  String? boardingPointValue;
  String? dropOffPoint;
  String? selectedPriceRange;
  String? tpyeOffcar;

  List<String> dropdownFromValueItems = []; // รายการเพื่อเก็บข้อมูลใน Dropdown
  List<String> dropdownToValueItems = [];
  List<String> dropdownBoardingPointValueItems = [];
  List<String> dropdownDropOffPointItems = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    // ดึงข้อมูลจาก Firebase
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Province').get();
    QuerySnapshot querySnapshotTow =
        await FirebaseFirestore.instance.collection('Route').get();

    // นำข้อมูลมาเติมใน dropdownItems
    //จังหวัดต้นทาง
    for (var doc in querySnapshot.docs) {
      dropdownFromValueItems.add(
          doc['province']); // เปลี่ยน 'field_name' เป็นชื่อฟิลด์ที่คุณต้องการ
    }
    //จังหวักปลายทาง
    for (var doc in querySnapshot.docs) {
      dropdownToValueItems.add(
          doc['province']); // เปลี่ยน 'field_name' เป็นชื่อฟิลด์ที่คุณต้องการ
    }
    //จุดขึ้นรถ
    for (var doc in querySnapshotTow.docs) {
      dropdownBoardingPointValueItems
          .add(doc['route']); // เปลี่ยน 'field_name' เป็นชื่อฟิลด์ที่คุณต้องการ
    }
    //จุดลงรถ
    for (var doc in querySnapshotTow.docs) {
      dropdownDropOffPointItems
          .add(doc['route']); // เปลี่ยน 'field_name' เป็นชื่อฟิลด์ที่คุณต้องการ
    }

    setState(() {}); // อัพเดต UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาแบบละเอียด'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    width: 380,
                    //height: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Text("จาก", style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          fromProvince(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Text("จุดขึ้นรถ",
                                    style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          fromPickup(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Text("ถึง", style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          toProvince(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child:
                                    Text("จุดลงรถ", style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          toDropPoint(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child:
                                    Text("ช่วงราคา", style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          priceRange(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child:
                                    Text("ประเภทรถ", style: Textstyle().text18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          tpyeOffCar(),
                          const SizedBox(height: 20),
                          bottomSeach(context),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField2<String> tpyeOffCar() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text('กรุณาเลือกประเภทรถ', style: Textstyle().text16),
      items: [
        "วีไอพี24 (ม.1 ก)",
        "รถป.1 (ม.1 ข)",
        "วีไอพี32 (ม.1 พ)",
        "วีไอพี24 (ม.4 ก)",
        "รถป.1 (ม.4 ข)",
        "รถป.2 (ม.4 ค)",
        "วีไอพี32 (ม.4 พ)",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกประเภทรถ';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          tpyeOffcar = newValue!;
        });
      },
      value: tpyeOffcar,
      onSaved: (value) {
        tpyeOffcar = value.toString();
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  DropdownButtonFormField2<String> priceRange() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text('กรุณาเลือกช่วงราคา', style: Textstyle().text16),
      items: ["0 - 300", "301 - 600", "601 - 999", "1000 ขึ้นไป"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกช่วงราคา';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          selectedPriceRange = newValue!;
        });
      },
      value: selectedPriceRange,
      onSaved: (value) {
        selectedPriceRange = value.toString();
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 225,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  int? selectedPriceMin;
  int? selectedPriceMax;

  void extractPriceRange(String selectedPriceRange) {
    if (selectedPriceRange == "0 - 300") {
      selectedPriceMin = 0;
      selectedPriceMax = 300;
    } else if (selectedPriceRange == "301 - 600") {
      selectedPriceMin = 301;
      selectedPriceMax = 600;
    } else if (selectedPriceRange == "601 - 999") {
      selectedPriceMin = 601;
      selectedPriceMax = 999;
    } else if (selectedPriceRange == "1000 ขึ้นไป") {
      selectedPriceMin = 1000;
      selectedPriceMax = null; // ไม่มีส่วนสูงสุดสำหรับกรณีนี้
    }
  }

  SizedBox bottomSeach(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: FloatingActionButton.extended(
        label: Text('ค้นหา', style: Textstyle().text18),
        heroTag: 'ค้นหา',
        backgroundColor: const Color.fromARGB(255, 65, 200, 241),
        icon: const Icon(
          Icons.search,
          size: 18,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (fromValue != null &&
                boardingPointValue != null &&
                toValue != null &&
                dropOffPoint != null &&
                selectedPriceRange != null &&
                tpyeOffcar != null) {
              var query = FirebaseFirestore.instance
                  .collection('ListCar')
                  .where('Origin', isEqualTo: fromValue)
                  .where('PickUp', isEqualTo: boardingPointValue)
                  .where('Destination', isEqualTo: toValue)
                  .where('DropOff', isEqualTo: dropOffPoint)
                  .where('Price', isGreaterThanOrEqualTo: selectedPriceRange)
                  .where('TypeofCar', isEqualTo: tpyeOffcar);

              query.get().then((querySnapshot) {
                // สร้างรายการข้อมูลที่ตรงกับเงื่อนไขทั้งหมด
                List<CarData> matchingCars = [];
                for (var doc in querySnapshot.docs) {
                  var carData = CarData(
                    id: doc.id,
                    origin: doc['Origin'],
                    pickUp: doc['PickUp'],
                    destination: doc['Destination'],
                    dropOff: doc['DropOff'],
                    nameTour: doc['NameTour'],
                    price: doc['Price'],
                    departureTime: doc['DepartureTime'],
                    timetoArrive: doc['TimetoArrive'],
                    typeofCar: doc['TypeofCar'],
                    imageUrlCar: doc['imageUrlCar'],
                    restStop: doc['RestStop'],
                    service: doc['service'],
                    round: doc['round'],
                  );

                  matchingCars.add(carData);
                }

                // ส่งข้อมูลที่ตรงกับเงื่อนไขทั้งหมดไปยังหน้าใหม่
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterResult(cars: matchingCars),
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }

  DropdownButtonFormField2<String> fromProvince() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text('กรุณาเลือกจังหวัดต้นทาง', style: Textstyle().text16),
      items:
          dropdownFromValueItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกจังหวัดต้นทาง';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          fromValue = newValue!;
        });
      },
      value: fromValue,
      onSaved: (value) {
        fromValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 0),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  DropdownButtonFormField2<String> fromPickup() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text(
        'กรุณาเลือกจุดขึ้นรถ',
        style: Textstyle().text16,
      ),
      items: dropdownBoardingPointValueItems
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกจุดขึ้นรถ';
        }
        return null;
      },
      value: boardingPointValue,
      onChanged: (String? newValue) {
        setState(() {
          boardingPointValue = newValue!;
        });
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 275,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  DropdownButtonFormField2<String> toProvince() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text(
        'กรุณาเลือกจังหวัดปลายทาง',
        style: Textstyle().text16,
      ),
      items: dropdownToValueItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกจังหวัดปลายทาง';
        }
        return null;
      },
      value: toValue,
      onChanged: (String? newValue) {
        setState(() {
          toValue = newValue!;
        });
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  DropdownButtonFormField2<String> toDropPoint() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: Text(
        'กรุณาเลือกจุดลงรถ',
        style: Textstyle().text16,
      ),
      items: dropdownDropOffPointItems
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Textstyle().text18,
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'กรุณาเลือกจุดลงรถ';
        }
        return null;
      },
      value: dropOffPoint,
      onChanged: (String? newValue) {
        setState(() {
          dropOffPoint = newValue!;
        });
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 275,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
