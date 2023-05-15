import 'package:flutter/material.dart';

class ListCompany extends StatefulWidget {
  const ListCompany({super.key});

  @override
  State<ListCompany> createState() => _ListCompanyState();
}

class _ListCompanyState extends State<ListCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายชื่อบริษัททัวร์")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Image.asset(
                      "icons/nca.png",
                      width: 100,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "นครชัยแอร์",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    "icons/ca.png",
                    width: 80,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "โชคอนันต์ทัวร์",
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    "icons/logotbus.png",
                    width: 80,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "โชคอนันต์ทัวร์",
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
