// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, camel_case_types

// เทสรายอะเอียดเพิ่มจังหวัด จุดลงรถ ลบ แก้ไข
class Detail_model {
  final id, province;

  Detail_model({
    this.id,
    this.province,
  });
  //map data to firebase
  Map<String, dynamic> add_detail() {
    return {
      'province': province,
    };
  }
}

//รายละเอียดจุดจำหน่ายตั๋ว
class Detail_SaleTicket_model {
  final id, name, address, officeHours, contact, latitude, longitude;

  Detail_SaleTicket_model(
      {this.id,
      this.name,
      this.address,
      this.officeHours,
      this.contact,
      this.latitude,
      this.longitude});
  //map data to firebase
  Map<String, dynamic> add_detail_ticket() {
    return {
      'name': name,
      'address': address,
      'contact': contact,
      'officeHours': officeHours,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

///car
class car_model {
  final id,
      NameTour,
      Origin,
      Destination,
      PickUp,
      DropOff,
      Keyword,
      Price,
      DepartureTime,
      TimetoArrive,
      TypeofCar,
      imageUrlCar,
      RestStop,
      service,
      round;
  car_model({
    this.id,
    this.NameTour,
    this.Origin,
    this.Destination,
    this.Keyword,
    this.Price,
    this.DepartureTime,
    this.TimetoArrive,
    this.PickUp,
    this.DropOff,
    this.TypeofCar,
    this.imageUrlCar,
    this.RestStop,
    this.service,
    this.round,
  });
  //map data to firebase
  Map<String, dynamic> add_data() {
    return {
      'NameTour': NameTour,
      'Origin': Origin,
      'Destination': Destination,
      'Keyword': Keyword,
      'Price': Price,
      'DepartureTime': DepartureTime,
      'TimetoArrive': TimetoArrive,
      'PickUp': PickUp,
      'DropOff': DropOff,
      'TypeofCar': TypeofCar,
      'imageUrlCar': imageUrlCar,
      'RestStop': RestStop,
      'service': service,
      'round': round,
    };
  }
}

//company
class company_model {
  final id,
      ImageUrlLogo,
      NameTour,
      Number,
      Northeast,
      Central,
      Southern,
      Northern,
      Eastern;
  company_model({
    this.id,
    this.ImageUrlLogo,
    this.NameTour,
    this.Number,
    this.Northeast,
    this.Central,
    this.Southern,
    this.Northern,
    this.Eastern,
  });
  Map<String, dynamic> add_company() {
    return {
      'id': id,
      'ImageUrlLogo': ImageUrlLogo,
      'NameTour': NameTour,
      'Number': Number,
      'Northeast': Northeast,
      'Central': Central,
      'Southern': Southern,
      'Northern': Northern,
      'Eastern': Eastern,
    };
  }
}

////newsAndPromotion
class newsAndPromotion_model {
  final id, Topic, Detail, imageUrlNews, time;

  newsAndPromotion_model({
    this.id,
    this.Topic,
    this.Detail,
    this.imageUrlNews,
    this.time,
  });
  //map data to firebase
  Map<String, dynamic> add_newsAndPromotion() {
    return {
      'Topic': Topic,
      'Detail': Detail,
      'imageUrlNews': imageUrlNews,
      'time': time,
    };
  }
}

// map
class mapLocation_model {
  final id, latitude, longitude, name, address;

  mapLocation_model({
    this.id,
    this.latitude,
    this.longitude,
    this.name,
    this.address,
  });
  //map data to firebase
  Map<String, dynamic> add_mapLocation() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'address': address,
    };
  }
}
