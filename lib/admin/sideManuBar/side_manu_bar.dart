import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/add_edit/add_edit_car.dart';
import 'package:runnn/admin/add_edit/add_edit_company.dart';
import 'package:runnn/admin/add_edit/add_edit_news_promotion.dart';
import 'package:runnn/admin/chatAdmin/all_chat.dart';
import 'package:runnn/admin/mapadmin/add_edit_map.dart';
import 'package:runnn/admin/mapadmin/open_map_admin.dart';
import 'package:runnn/admin/sideManuBar/add_detail_dropdown.dart';
import 'package:runnn/admin/sideManuBar/car_admin.dart';
import 'package:runnn/admin/sideManuBar/company_admin.dart';
import 'package:runnn/admin/mapadmin/map_admin.dart';
import 'package:runnn/admin/sideManuBar/news_promotion.dart';
import 'package:runnn/admin/sideManuBar/report.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';

class SideBarManu extends StatefulWidget {
  const SideBarManu({super.key});

  @override
  State<SideBarManu> createState() => _SideBarManuState();
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Home Page"),
    );
  }
}

//เที่ยวรถ
class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarAdmin();
  }
}

//บริษัท
class Company extends StatelessWidget {
  const Company({super.key});

  @override
  Widget build(BuildContext context) {
    return const CompanyAdmin();
  }
}

//ข่าวสาร
class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return const newsPromotion();
  }
}

//แชท
class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllChat();
  }
}

//เพิ่มแผนที่
class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapAdmid();
  }
}

//แผนที่
class MapLocationOpen extends StatelessWidget {
  const MapLocationOpen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenMapAdmin();
  }
}

//รายงาน
class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportAdmin();
  }
}

//เพิ่มข้อมูลลงดรอบดาวน์
class AddDetail extends StatelessWidget {
  const AddDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return AddDetailDropdown();
  }
}

class _SideBarManuState extends State<SideBarManu> {
  String appBarTitle = "Home"; // Title ของ AppBar ที่เปลี่ยนไปตามหน้าต่าง
  int currentPageIndex = 0; // หน้าปัจจุบัน

  // รายการเมนูใน Drawer
  final List<MenuItem> menuItems = [
    MenuItem(
      title: "Home",
      icon: Icons.home,
    ),
    MenuItem(title: "เที่ยวรถทัวร์", icon: Icons.directions_bus),
    MenuItem(title: "รายชื่อบริษัททัวร์", icon: Icons.business),
    MenuItem(title: "ข่าวสาร โปรโมชั่น", icon: Icons.newspaper),
    MenuItem(title: "แชทสนทนา", icon: Icons.message),
    MenuItem(title: "จุดจำหน่ายตั๋ว", icon: Icons.edit_location),
    MenuItem(title: "ดูจุดจำหน่ายตั๋วบนแผนที่", icon: Icons.map),
    MenuItem(title: "แดชบอร์ด", icon: Icons.dashboard),
    MenuItem(title: "เพิ่มรายละเอียดต่างๆ", icon: Icons.details),
    MenuItem(title: "ออกจากระบบ", icon: Icons.logout),
  ];

  // Widget สำหรับเปลี่ยนหน้าตามรายการเมนูที่เลือก
  List<Widget> pages = [
    const HomePage(),
    const Car(),
    const Company(),
    const News(),
    const Chat(),
    const Map(),
    const MapLocationOpen(),
    const Report(),
    const AddDetail(),
  ];

  Future logout() async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  List<Widget> _buildAppBarActions() {
    // ตรวจสอบหน้าปัจจุบันและสร้าง actions ที่เหมาะสม
    if (currentPageIndex == 0) {
      // หน้า Home
      return [];
    } else if (currentPageIndex == 1) {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const addEditCar()));
          },
        ),
      ];
    } else if (currentPageIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const addEditCompany()));
          },
        ),
      ];
    } else if (currentPageIndex == 3) {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const addEditNewPromotion()));
          },
        ),
      ];
    } else if (currentPageIndex == 5) {
      return [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddEditMap()));
          },
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: Textstyle().textTitleAppbar,
        ), // กำหนด Title ของ AppBar ตามสถานะ appBarTitle
        actions: _buildAppBarActions(),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(menuItems[index].icon),
              title: Text(
                menuItems[index].title,
                style: Textstyle().text18,
              ),
              onTap: () {
                if (menuItems[index].title == "ออกจากระบบ") {
                  logout(); // Call the logout function for this menu item
                } else {
                  setState(() {
                    appBarTitle = menuItems[index].title;
                    currentPageIndex = index;
                  });
                }
                Navigator.pop(context); // ปิด Drawer เมื่อเลือกเมนู
              },
            );
          },
        ),
      ),
      body: pages[currentPageIndex], // แสดงหน้าที่เลือกในเมนู
    );
  }
}
