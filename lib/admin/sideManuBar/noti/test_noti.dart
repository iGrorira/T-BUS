import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/admin/sideManuBar/noti/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:runnn/const/appcolors.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({super.key});

  @override
  State<NotificationTest> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  final provinces = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProvince() {
    firestore.collection('ProvinceSo').add({
      "province": provinces.text,
    });
  }

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    //notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('Device Token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notification'),
      ),
      body: Center(
        child: Column(
          children: [
            proVinces(),
            const SizedBox(width: 12),
            SizedBox(
              child: FloatingActionButton.extended(
                label: Text('เพิ่มจังหวัด', style: Textstyle().text18),
                heroTag: 'เพิ่มจังหวัด',
                backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                onPressed: () {
                  if (provinces.text.isNotEmpty) {
                    // เช็คว่ามีข้อมูลที่กรอกเข้ามาหรือไม่
                    addProvince();
                    sendNotificationsToAllToken();
                    //sendPushNotifification();
                    Fluttertoast.showToast(msg: "เพิ่มข้อมูลสำเร็จ");
                  } else {
                    Fluttertoast.showToast(msg: "กรุณากรอกจุดจอดรถ");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*testTest() {
    notificationServices.getDeviceToken().then((value) async {
      var data = {
        'to':
            'fEagatCHSJWReV5EkM_fWv:APA91bHCPAKOjdEYo4Hl44bb0g4dYO2Ak1DL63XafQvNsmMuRlIee5mvslZiNvZerKVWQu47rwsJlisFqX0kcUC7CRtAed0hL5S3shEcLgkuOl2551NndK2cdFya2ewe_56KIQ-8KEi1',
        'priority': 'high',
        'notification': {'title': provinces.text, 'body': "Hello word!!!!"},
        'data': {
          'type': 'msj',
          'id': '1234',
        }
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAwRmBeUo:APA91bH9mfFenKTZc625Q3uOf-jDO8l6qi6VYyPOhgvFPR71AFboVO619aJ6gY7uuM6uA6P7dSSKzhQm41jR8C6n_B7Cmg6TgKzOjn93QrER7ThU1Q_Ec2LHcxjKDG91_176iTqOMyOh',
          });
    });
  }*/

  void sendNotificationsToAllToken() {
    // ดึงค่าทั้งหมดจากคอลเลกชัน "token" ใน Firestore
    FirebaseFirestore.instance.collection('token').get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // สร้าง JSON ข้อมูลสำหรับการส่งข้อความแจ้งเตือน
        var data = {
          'priority': 'high',
          'notification': {
            'title': provinces.text, // Change to your desired title
            'body': 'Hello word!!!!', // Change to your desired body
          },
          'data': {
            'type': 'msj',
            'id': '1234',
          }
        };

        // วนลูปผ่านทุกเอกสารในคอลเลกชัน "token" เพื่อส่งการแจ้งเตือน
        for (var doc in querySnapshot.docs) {
          String toValue =
              doc['token']; // ใช้ doc['token'] แทน doc.data()['token']
          if (toValue.isNotEmpty) {
            // เพิ่มค่า "to" ใน JSON ข้อมูล
            data['to'] = toValue;

            // ส่งคำขอ HTTP ไปยัง FCM
            http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAwRmBeUo:APA91bH9mfFenKTZc625Q3uOf-jDO8l6qi6VYyPOhgvFPR71AFboVO619aJ6gY7uuM6uA6P7dSSKzhQm41jR8C6n_B7Cmg6TgKzOjn93QrER7ThU1Q_Ec2LHcxjKDG91_176iTqOMyOh', // Replace with your FCM server key
              },
            );
          }
        }
      }
    });
  }

  /*Future<void> sendPushNotifification() async {
    try {
      final body = {
        "to":
            'fEagatCHSJWReV5EkM_fWv:APA91bHCPAKOjdEYo4Hl44bb0g4dYO2Ak1DL63XafQvNsmMuRlIee5mvslZiNvZerKVWQu47rwsJlisFqX0kcUC7CRtAed0hL5S3shEcLgkuOl2551NndK2cdFya2ewe_56KIQ-8KEi1',
        "notification": {
          "title": provinces.text,
          "body": "Hello word!!!!",
        },
      };
      var res =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAwRmBeUo:APA91bH9mfFenKTZc625Q3uOf-jDO8l6qi6VYyPOhgvFPR71AFboVO619aJ6gY7uuM6uA6P7dSSKzhQm41jR8C6n_B7Cmg6TgKzOjn93QrER7ThU1Q_Ec2LHcxjKDG91_176iTqOMyOh'
              },
              body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotifificationE: $e');
    }
  }*/

  SizedBox proVinces() {
    return SizedBox(
      width: 500,
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        keyboardType: TextInputType.text,
        controller: provinces,
        decoration: InputDecoration(
          labelText: 'จังหวัด',
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
}
