class VehicleRegistrationData {
  final String brand;
  final String model;
  final int year;
  final String regNum;
  final String? interiorPhoto;
  final String? exteriorPhoto;
  final int courierTypeId;

  VehicleRegistrationData({
    required this.brand,
    required this.model,
    required this.year,
    required this.regNum,
    this.interiorPhoto,
    this.exteriorPhoto,
    required this.courierTypeId,
  });

  factory VehicleRegistrationData.fromJson(Map<String, dynamic> json) {
    return VehicleRegistrationData(
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      regNum: json['reg_num'],
      interiorPhoto: json['interior_photo'],
      exteriorPhoto: json['exterior_photo'],
      courierTypeId: json['courier_type_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'reg_num': regNum,
      'interior_photo': interiorPhoto,
      'exterior_photo': exteriorPhoto,
      'courier_type_id': courierTypeId,
    };
  }
}

class LicenseRegistrationData {
  final String number;
  final String? frontImg;
  final String? backImg;
  final String expiryDate;
  final String issuedAt;

  LicenseRegistrationData({
    required this.number,
    this.frontImg,
    this.backImg,
    required this.expiryDate,
    required this.issuedAt,
  });

  factory LicenseRegistrationData.fromJson(Map<String, dynamic> json) {
    return LicenseRegistrationData(
      number: json['number'],
      frontImg: json['front_img'],
      backImg: json['back_img'],
      expiryDate: json['expiry_date'],
      issuedAt: json['issued_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'front_img': frontImg,
      'back_img': backImg,
      'expiry_date': expiryDate,
      'issued_at': issuedAt,
    };
  }
}

class RiderRegistrationRequest {
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String password;
  final VehicleRegistrationData vehicle;
  final LicenseRegistrationData license;

  RiderRegistrationRequest({
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
    required this.vehicle,
    required this.license,
  });

  factory RiderRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RiderRegistrationRequest(
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      vehicle: VehicleRegistrationData.fromJson(json['vehicle']),
      license: LicenseRegistrationData.fromJson(json['license']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
      'password': password,
      'vehicle': vehicle.toJson(),
      'license': license.toJson(),
    };
  }
}

class OtpVerificationRequest {
  final String email;
  final String otp;

  OtpVerificationRequest({
    required this.email,
    required this.otp,
  });

  factory OtpVerificationRequest.fromJson(Map<String, dynamic> json) {
    return OtpVerificationRequest(
      email: json['email'],
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
