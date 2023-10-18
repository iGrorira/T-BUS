// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:runnn/const/appcolors.dart';

class addEditCompany extends StatefulWidget {
  final index;
  final company_model? company;
  const addEditCompany({super.key, this.company, this.index});

  @override
  State<addEditCompany> createState() => _addEditCompanyState();
}

class _addEditCompanyState extends State<addEditCompany> {
  String _imageFile = '';
  // Variable to hold the selected image file
  Uint8List? selectedImageInBytes;
  final id = TextEditingController();
  final NameTour = TextEditingController();
  final Number = TextEditingController();
  final Northeast = TextEditingController();
  final Central = TextEditingController();
  final Southern = TextEditingController();
  final Northern = TextEditingController();
  final Eastern = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEditingMode = false;
  @override
  void initState() {
    if (widget.index != null) {
      isEditingMode = true;
      id.text = widget.company?.id;
      NameTour.text = widget.company?.NameTour;
      Number.text = widget.company?.Number;
      Northeast.text = widget.company?.Northeast;
      Central.text = widget.company?.Central;
      Southern.text = widget.company?.Southern;
      Northern.text = widget.company?.Northern;
      Eastern.text = widget.company?.Eastern;
      ImageUrlLogo = widget.company?.ImageUrlLogo;
      selectedImageInBytes = null;
    } else {
      isEditingMode = false;
    }
    super.initState();
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
  String ImageUrlLogo = '';
  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      final timeImage = DateTime.now().toString();
      // This is referance where image uploaded in firebase storage bucket
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('CompanyLogo/$_imageFile$timeImage');

      // metadata to save image extension
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // UploadTask to finally upload image
      UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

      // After successfully upload show SnackBar
      await uploadTask.whenComplete(() => ScaffoldMessenger.of(context));
      return ImageUrlLogo = await ref.getDownloadURL();
    } catch (e) {
      // If an error occured while uploading, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditingMode == true
            ? const Text('แก้ไขบริษัทรถทัวร์')
            : const Text('เพิ่มบริษัทรถทัวร์'),
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
                      Text(
                        'อัพโหลดภาพหรือโลโก้บริษัท',
                        style: Textstyle().text20,
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: 200,
                          height: 180,
                          child: isEditingMode == true
                              ? _imageFile.isEmpty
                                  ? Image.network(ImageUrlLogo)
                                  : Image.memory(selectedImageInBytes!)
                              : _imageFile.isNotEmpty
                                  ? Image.memory(selectedImageInBytes!)
                                  : const Icon(
                                      Icons.photo,
                                      size: 200,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            elevation: 3,
                          ),
                          onPressed: () {
                            pickImage();
                          },
                          child: Text('เพิ่มรูปภาพ',
                              style: Textstyle().buttomTextWhite),
                        ),
                      ),
                      const SizedBox(height: 10),
                      nametour(),
                      const SizedBox(height: 10),
                      number(),
                      const SizedBox(height: 10),
                      Text('รายละเอียดเส้นทางการเดินรถ',
                          style: Textstyle().text16),
                      const SizedBox(height: 10),
                      northeast(),
                      const SizedBox(height: 10),
                      northern(),
                      const SizedBox(height: 10),
                      southern(),
                      const SizedBox(height: 10),
                      central(),
                      const SizedBox(height: 10),
                      eastern(),
                      const SizedBox(height: 10),
                      buttom(context),
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

  Center buttom(BuildContext context) {
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
                  company_controller().update_company(company_model(
                    id: id.text,
                    ImageUrlLogo: ImageUrlLogo,
                    NameTour: NameTour.text,
                    Number: Number.text,
                    Northeast: Northeast.text,
                    Central: Central.text,
                    Southern: Southern.text,
                    Northern: Northern.text,
                    Eastern: Eastern.text,
                  ));
                } else {
                  await uploadImage(selectedImageInBytes!);
                  FirebaseFirestore.instance.collection('nameTour').doc().set({
                    'NameTour': NameTour.text,
                  });
                  company_controller().add_company(
                    company_model(
                      ImageUrlLogo: ImageUrlLogo,
                      NameTour: NameTour.text,
                      Number: Number.text,
                      Northeast: Northeast.text,
                      Central: Central.text,
                      Southern: Southern.text,
                      Northern: Northern.text,
                      Eastern: Eastern.text,
                    ),
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
                Fluttertoast.showToast(msg: "เพิ่มเพิ่มบริษัทรถทัวร์สำเร็จ");
              } else {
                Fluttertoast.showToast(msg: "เพิ่มบริษัทรถทัวร์ไม่สำเร็จ");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              elevation: 3,
            ),
            child: isEditingMode == true
                ? Text("บันทึกข้อมูล", style: Textstyle().buttomTextWhite)
                : Text("เพิ่มบริษัททัวร์", style: Textstyle().buttomTextWhite),
          ),
        ),
      ),
    );
  }

  TextFormField nametour() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: NameTour,
      style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'ชื่อบริษัททัวร์',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่ชื่อบริษัททัวร์';
        }
        return null;
      },
    );
  }

  TextFormField number() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: Number,
      style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'เบอร์ติดต่อ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่ชื่อบริษัททัวร์';
        }
        return null;
      },
    );
  }

  Container eastern() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 90,
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
        controller: Eastern,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ภาคตะวันออก',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รายละเอียด';
          }
          return null;
        },
      ),
    );
  }

  Container northern() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 90,
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
        controller: Northern,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ภาคเหนือ',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รายละเอียด';
          }
          return null;
        },
      ),
    );
  }

  Container southern() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 90,
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
        controller: Southern,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ภาคใต้',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รายละเอียด';
          }
          return null;
        },
      ),
    );
  }

  SizedBox central() {
    return SizedBox(
      height: 90,
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
        controller: Central,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ภาคกลาง',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รายละเอียด';
          }
          return null;
        },
      ),
    );
  }

  SizedBox northeast() {
    return SizedBox(
      height: 90,
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(fontSize: 16, color: Colors.black),
        controller: Northeast,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ภาคอีสาน',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รายละเอียด';
          }
          return null;
        },
      ),
    );
  }
}
