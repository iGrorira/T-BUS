import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runnn/ui/list_company.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 21, 79, 224),
        leading: const Icon(Icons.home),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  //controller: _searchController,

                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'ค้นหาข้อมูลรถทัวร์ที่นี่',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 65, 117)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 90,
                width: 350,
                child: FloatingActionButton.extended(
                    label: const Text(
                      'รายชื่อรถทัวร์',
                      style: TextStyle(fontSize: 24),
                    ),
                    heroTag: 'รายชื่อรถทัวร์',
                    backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                    icon: const Icon(
                      Icons.directions_bus_filled_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => const ListCompany()));
                    }),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 90,
                width: 350,
                child: FloatingActionButton.extended(
                  label: const Text(
                    'สอบถามข้อมูล',
                    style: TextStyle(fontSize: 24),
                  ),
                  heroTag: 'สอบถามข้อมูล',
                  backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                  icon: const Icon(
                    Icons.chat,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 90,
                width: 350,
                child: FloatingActionButton.extended(
                  label: const Text(
                    'ข่าวสาร',
                    style: TextStyle(fontSize: 24),
                  ),
                  heroTag: 'ข่าวสาร',
                  backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                  icon: const Icon(
                    Icons.notifications_active,
                    size: 50,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 90,
                width: 350,
                child: FloatingActionButton.extended(
                  label: const Text(
                    'ขนส่งใกล้ฉัน',
                    style: TextStyle(fontSize: 24),
                  ),
                  heroTag: 'ขนส่งใกล้ฉัน',
                  backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                  icon: const Icon(
                    Icons.maps_home_work,
                    size: 45,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
