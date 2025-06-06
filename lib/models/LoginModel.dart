class LoginModel {
  String id = "";
  String email = "";
  String country = "";
  String birthdate = "";
  bool emailConfirmed = false;
  int createAt = 0;
  String imei = "";
  String token = "";

  LoginModel({
    required this.id,
    required this.birthdate,
    required this.country,
    required this.createAt,
    required this.email,
    required this.emailConfirmed,
    required this.imei,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        birthdate: json['birthdate'],
        country: json['country'],
        createAt: json['createAt'],
        email: json['email'],
        emailConfirmed: json['emailConfirmed'],
        id: json['_id'],
        imei: json['imei'],
        token: json['token']);
  }
}
