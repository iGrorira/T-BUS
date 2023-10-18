// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appcolors.dart';

class addEditCar extends StatefulWidget {
  final car_model? car;
  final index;
  const addEditCar({super.key, this.car, this.index});

  @override
  State<addEditCar> createState() => _addEditCarState();
}

class _addEditCarState extends State<addEditCar> {
  String _imageFile = '';
  Uint8List? selectedImageInBytes;
  final id = TextEditingController();
  final Keyword = TextEditingController();
  final Origin = TextEditingController();
  final Destination = TextEditingController();
  final Price = TextEditingController();
  final DepartureTime = TextEditingController();
  final TimetoArrive = TextEditingController();
  final PickUp = TextEditingController();
  final DropOff = TextEditingController();
  final RestStop = TextEditingController();
  final service = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isEditingMode = false;

  String? fromValue;
  String? toValue;
  String? boardingPointValue;
  String? dropOffPointValue;
  String? tpyeOffcar;
  String? nameCompany;
  String? RounCar;

  // รายการเพื่อเก็บข้อมูลใน Dropdown
  List<String> dropdownNameCompanyItems = [];
  List<String> dropdownFromValueItems = [];
  List<String> dropdownToValueItems = [];
  List<String> dropdownBoardingPointValueItems = [];
  List<String> dropdownDropOffPointItems = [];
  //dropdown
  Future<void> fetchDataFromFirebase() async {
    // ดึงข้อมูลจาก Firebase
    QuerySnapshot queryProvince = await FirebaseFirestore.instance
        .collection('Province')
        .orderBy('province', descending: false)
        .get();
    QuerySnapshot queryRoute = await FirebaseFirestore.instance
        .collection('Route')
        .orderBy('route', descending: false)
        .get();
    QuerySnapshot queryCompany = await FirebaseFirestore.instance
        .collection('nameTour')
        .orderBy('NameTour', descending: false)
        .get();

    // นำข้อมูลมาเติมใน dropdownItems
    //จังหวัดต้นทาง
    for (var doc in queryProvince.docs) {
      dropdownFromValueItems.add(doc['province']);
    }
    //จังหวักปลายทาง
    for (var doc in queryProvince.docs) {
      dropdownToValueItems.add(doc['province']);
    }
    //จุดขึ้นรถ
    for (var doc in queryRoute.docs) {
      dropdownBoardingPointValueItems.add(doc['route']);
    }
    //จุดลงรถ
    for (var doc in queryRoute.docs) {
      dropdownDropOffPointItems.add(doc['route']);
    }

    //ชื่อบริษัท
    for (var doc in queryCompany.docs) {
      dropdownNameCompanyItems.add(doc['NameTour']);
    }

    setState(() {}); // อัพเดต UI
  }

  @override
  void initState() {
    fetchDataFromFirebase();
    if (widget.index != null) {
      isEditingMode = true;
      id.text = widget.car?.id;
      nameCompany = widget.car?.NameTour;
      Keyword.text = widget.car?.Keyword;
      fromValue = widget.car?.Origin;
      toValue = widget.car?.Destination;
      Price.text = widget.car?.Price;
      DepartureTime.text = widget.car?.DepartureTime;
      TimetoArrive.text = widget.car?.TimetoArrive;
      boardingPointValue = widget.car?.PickUp;
      dropOffPointValue = widget.car?.DropOff;
      tpyeOffcar = widget.car?.TypeofCar;
      imageUrlCar = widget.car?.imageUrlCar;
      service.text = widget.car?.service;
      RestStop.text = widget.car?.RestStop;
      RounCar = widget.car?.round;
      selectedImageInBytes = null;
    } else {
      isEditingMode = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditingMode == true
            ? Text(
                'แก้ไขเที่ยวรถทัวร์',
                style: GoogleFonts.baiJamjuree(color: Colors.white),
              )
            : Text(
                'เพิ่มเที่ยวรถทัวร์',
                style: GoogleFonts.baiJamjuree(color: Colors.white),
              ),
        backgroundColor: Colors.blueAccent[500],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 1120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('อัพโหลดรูปภาพรถ', style: Textstyle().text20),
                      photoImage(),
                      const SizedBox(height: 20),
                      bottomPickImage(),
                      const SizedBox(height: 10),
                      Text('ชื่อบริษัท', style: Textstyle().text16),
                      const SizedBox(height: 5),
                      DropdownNameCompany(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("จาก", style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                dropdrowFromField(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("จุดขึ้นรถ",
                                        style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                dropdrowPickUp(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("จังหวัดปลายทาง",
                                        style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                DropdownDestination(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("จุดลงรถ", style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                DropdownDropOff(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("รอบรถ", style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                rounCar(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 95,
                            width: 550,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ประเภทรถ", style: Textstyle().text16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                tpyeOffCar(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 550,
                            child: Departuretime(),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: 70,
                            width: 550,
                            child: TimeToArrive(),
                          ),
                        ],
                      ),
                      price(),
                      const SizedBox(height: 10),
                      keyword(),
                      const SizedBox(height: 10),
                      restStop(),
                      const SizedBox(height: 10),
                      serve(),
                      const SizedBox(height: 10),
                      Buttom(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField2<String> rounCar() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      hint: Text('กรุณาเลือกรอบรถ', style: Textstyle().text16),
      items: [
        "รอบเช้า",
        "รอบเที่ยง",
        "รอบบ่าย",
        "รอบดึก",
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
          return 'กรุณาเลือกรอบรถ';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          RounCar = newValue!;
        });
      },
      value: RounCar,
      onSaved: (value) {
        RounCar = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> tpyeOffCar() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
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
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> DropdownNameCompany() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      hint: Text('กรุณาเลือกชื่อบริษัททัวร์', style: Textstyle().text16),
      items: dropdownNameCompanyItems
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
          return 'กรุณาเลือกชื่อบริษัททัวร์';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          nameCompany = newValue!;
        });
      },
      value: nameCompany,
      onSaved: (value) {
        nameCompany = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black54,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> dropdrowFromField() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
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
        padding: EdgeInsets.only(right: 8),
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> dropdrowPickUp() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
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
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> DropdownDestination() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
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
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  DropdownButtonFormField2<String> DropdownDropOff() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
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
      value: dropOffPointValue,
      onChanged: (String? newValue) {
        setState(() {
          dropOffPointValue = newValue!;
        });
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // Method to pick image in flutter web
  Future<void> pickImage() async {
    try {
      // Pick image using file_picker package
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user picks an image, save selected image to variable
      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
      }
    } catch (e) {
      // If an error occured, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  // Method to upload selected image in flutter web
  // This method will get selected image in Bytes
  String imageUrlCar = '';
  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      final timeImage = DateTime.now().toString();
      // This is referance where image uploaded in firebase storage bucket
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('ImageCar/$_imageFile$timeImage');

      // metadata to save image extension
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // UploadTask to finally upload image
      UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

      // After successfully upload show SnackBar
      await uploadTask.whenComplete(() => ScaffoldMessenger.of(context));
      return imageUrlCar = await ref.getDownloadURL();
    } catch (e) {
      // If an error occured while uploading, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }

  Center bottomPickImage() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[300],
          elevation: 3,
        ),
        onPressed: () {
          // Calling pickImage Method
          pickImage();
        },
        child: Text('เพิ่มรูปภาพ', style: Textstyle().buttomTextWhite),
      ),
    );
  }

  Center photoImage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        width: 200,
        height: 180,
        child: isEditingMode == true
            ? _imageFile.isEmpty
                ? Image.network(imageUrlCar)
                : Image.memory(selectedImageInBytes!)
            : _imageFile.isNotEmpty
                ? Image.memory(selectedImageInBytes!)
                : const Icon(
                    Icons.photo,
                    size: 150,
                  ),
      ),
    );
  }

  Center Buttom(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75.0),
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (isEditingMode == true) {
                  if (selectedImageInBytes != null) {
                    await uploadImage(selectedImageInBytes!);
                  }
                  car_controller().update_car(
                    car_model(
                      id: id.text,
                      NameTour: nameCompany,
                      Origin: fromValue,
                      Destination: toValue,
                      Keyword: Keyword.text,
                      Price: Price.text,
                      DepartureTime: DepartureTime.text,
                      TimetoArrive: TimetoArrive.text,
                      PickUp: boardingPointValue,
                      DropOff: dropOffPointValue,
                      TypeofCar: tpyeOffcar,
                      imageUrlCar: imageUrlCar,
                      RestStop: RestStop.text,
                      service: service.text,
                      round: RounCar,
                    ),
                  );
                } else {
                  await uploadImage(selectedImageInBytes!);
                  car_controller().add_car(
                    car_model(
                      NameTour: nameCompany,
                      Origin: fromValue,
                      Destination: toValue,
                      Keyword: Keyword.text,
                      Price: Price.text,
                      DepartureTime: DepartureTime.text,
                      TimetoArrive: TimetoArrive.text,
                      PickUp: boardingPointValue,
                      DropOff: dropOffPointValue,
                      TypeofCar: tpyeOffcar,
                      imageUrlCar: imageUrlCar,
                      RestStop: RestStop.text,
                      service: service.text,
                      round: RounCar,
                    ),
                  );
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }

                Fluttertoast.showToast(
                  msg: "เพิ่มเที่ยวรถสำเร็จ",
                  webPosition: Center,
                );
              } else {
                Fluttertoast.showToast(msg: "เพิ่มเที่ยวรถไม่สำเร็จ");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              elevation: 3,
            ),
            child: isEditingMode == true
                ? Text("บันทึกข้อมูล", style: Textstyle().buttomTextWhite)
                : Text("เพิ่มเที่ยวรถ", style: Textstyle().buttomTextWhite),
          ),
        ),
      ),
    );
  }

  TextFormField serve() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.text,
      controller: service,
      decoration: InputDecoration(
        labelText: 'บริการ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่บริการ';
        }
        return null;
      },
    );
  }

  TextFormField restStop() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.text,
      controller: RestStop,
      decoration: InputDecoration(
        labelText: 'จุดพักรถ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่จุดพักรถ';
        }
        return null;
      },
    );
  }

  TextFormField TimeToArrive() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.number,
      controller: TimetoArrive,
      decoration: InputDecoration(
        labelText: 'เวลารถถึง',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่เวลารถถึง';
        }
        return null;
      },
    );
  }

  TextFormField Departuretime() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.number,
      controller: DepartureTime,
      decoration: InputDecoration(
        labelText: 'เวลารถออก',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่เวลาออกรถ';
        }
        return null;
      },
    );
  }

  TextFormField price() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.number,
      controller: Price,
      decoration: InputDecoration(
        labelText: 'ราคา',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่ราคา';
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  TextFormField keyword() {
    return TextFormField(
      style: GoogleFonts.baiJamjuree(color: Colors.black),
      keyboardType: TextInputType.text,
      controller: Keyword,
      decoration: InputDecoration(
        labelText: 'คีย์เวิร์ด',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่คีย์เวิร์ด';
        }
        return null;
      },
    );
  }
}
