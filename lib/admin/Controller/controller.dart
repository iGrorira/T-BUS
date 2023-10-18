// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runnn/admin/model/model.dart';

// เทสรายอะเอียดเพิ่มจังหวัด จุดลงรถ
final CollectionReference _detail =
    FirebaseFirestore.instance.collection("Province");

class detail_controller {
  // add data to firebase
  Future add_detail(Detail_model detail) async {
    await _detail.doc().set(detail.add_detail());
  }

  //update data
  Future update_detail(Detail_model detail) async {
    await _detail.doc(detail.id).update(detail.add_detail());
  }

  //detet data
  Future detele_detail(Detail_model detail) async {
    await _detail.doc(detail.id).delete();
  }
}

///เที่ยวรถ
final CollectionReference _cars =
    FirebaseFirestore.instance.collection("ListCar");

class car_controller {
  // add data to firebase
  Future add_car(car_model car) async {
    await _cars.doc().set(car.add_data());
  }

  //update data
  Future update_car(car_model car) async {
    await _cars.doc(car.id).update(car.add_data());
  }

  //detet data
  Future detele_car(car_model car) async {
    await _cars.doc(car.id).delete();
  }
}

//บริษัท
final CollectionReference _company =
    FirebaseFirestore.instance.collection("ListCompany");

class company_controller {
  // add data to firebase
  Future add_company(company_model company) async {
    await _company.doc().set(company.add_company());
  }

  //update data
  Future update_company(company_model company) async {
    await _company.doc(company.id).update(company.add_company());
  }

  //detet data
  Future detele_company(company_model company) async {
    await _company.doc(company.id).delete();
  }
}

///ข่าวสาร
final CollectionReference _newsAndPromotion =
    FirebaseFirestore.instance.collection("NewsAndPromotion");

class newsPromotion_controller {
  // add data to firebase
  Future add_newsPromotion(newsAndPromotion_model newsPromotion) async {
    await _newsAndPromotion.doc().set(newsPromotion.add_newsAndPromotion());
  }

  //update data
  Future update_newsPromotion(newsAndPromotion_model newsPromotion) async {
    await _newsAndPromotion
        .doc(newsPromotion.id)
        .update(newsPromotion.add_newsAndPromotion());
  }

  //detele data
  Future detele_newsPromotion(newsAndPromotion_model newsPromotion) async {
    await _newsAndPromotion.doc(newsPromotion.id).delete();
  }
}

//แผนที่
final CollectionReference _mapLocation =
    FirebaseFirestore.instance.collection("locations");

class map_controller {
  // add data to firebase
  Future add_map(mapLocation_model map) async {
    await _mapLocation.doc().set(map.add_mapLocation());
  }

  //update data
  Future update_map(mapLocation_model map) async {
    await _mapLocation.doc(map.id).update(map.add_mapLocation());
  }

  //detele data
  Future detele_map(mapLocation_model map) async {
    await _mapLocation.doc(map.id).delete();
  }
}
