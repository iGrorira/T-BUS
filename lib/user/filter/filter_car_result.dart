import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/user/filter/filter_car_detail.dart';

class CarData {
  final id;
  final String origin;
  final String pickUp;
  final String destination;
  final String dropOff;
  final String nameTour;
  final price;
  final String departureTime;
  final String timetoArrive;
  final String typeofCar;
  final imageUrlCar;
  final String restStop;
  final String service;
  final String round;

  CarData({
    required this.id,
    required this.origin,
    required this.pickUp,
    required this.destination,
    required this.dropOff,
    required this.nameTour,
    required this.price,
    required this.departureTime,
    required this.timetoArrive,
    required this.typeofCar,
    required this.imageUrlCar,
    required this.restStop,
    required this.service,
    required this.round,
  });
}

class FilterResult extends StatelessWidget {
  final List<CarData> cars;

  const FilterResult({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลลัพธ์'),
      ),
      body: cars.isEmpty
          ? Center(
              child: Text(
              'ไม่มีข้อมูล',
              style: Textstyle().text20,
            ))
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                var car = cars[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Set border width
                      border: Border.all(color: Colors.black45),
                      borderRadius: const BorderRadius.all(
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
                                  car.departureTime,
                                  style: GoogleFonts.baiJamjuree(
                                      fontSize: 20, color: Colors.black),
                                ),
                                Text(
                                  car.origin,
                                  style: GoogleFonts.baiJamjuree(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  car.nameTour,
                                  style: GoogleFonts.baiJamjuree(
                                      fontSize: 20, color: Colors.black),
                                ),
                                const Icon(
                                  Icons.directions_bus,
                                  color: Colors.blue,
                                ),
                                Text(
                                  car.typeofCar,
                                  style: GoogleFonts.baiJamjuree(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  car.timetoArrive,
                                  style: GoogleFonts.baiJamjuree(
                                      fontSize: 20, color: Colors.black),
                                ),
                                Text(
                                  car.destination,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CarDetailPageFilter(car: car),
                                  ),
                                );
                              },
                              child: Text(
                                "รายละเอียดเพิ่มเติม",
                                style: GoogleFonts.baiJamjuree(
                                    fontSize: 18,
                                    color: const Color.fromARGB(
                                        255, 93, 176, 244)),
                              ),
                            ),
                            Text(
                              "${car.price} บาท",
                              style: GoogleFonts.baiJamjuree(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
