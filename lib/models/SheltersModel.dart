class SheltersModel {
  String id;
  String name;
  String address1;
  String address2;
  String phones;
  int city_id;
  int province_id;
  bool status;
  int geolocation_id;
  int max_capacity;
  int current_number_of_people;
  String tipo;
  String created_at;
  String updated_at;
  double lat;
  double lng;
  String iso_code;
  String contact_phone_number;
  String contact_name;
  bool apto_inundaciones;
  bool apto_terremoto;
  String distance;
  String provinceName;

  SheltersModel({
    required this.address1,
    required this.address2,
    required this.apto_inundaciones,
    required this.apto_terremoto,
    required this.city_id,
    required this.contact_name,
    required this.contact_phone_number,
    required this.created_at,
    required this.current_number_of_people,
    required this.distance,
    required this.geolocation_id,
    required this.id,
    required this.iso_code,
    required this.lat,
    required this.lng,
    required this.max_capacity,
    required this.name,
    required this.phones,
    required this.province_id,
    required this.status,
    required this.tipo,
    required this.updated_at,
    required this.provinceName,
  });

  factory SheltersModel.fromJson(Map<String, dynamic> json) {
    return SheltersModel(
      id: json["id"],
      name: json["name"],
      address1: json["address1"],
      address2: json["address2"],
      status: json["status"],
      lat: json["lat"],
      lng: json["lng"],
      phones: json["phones"],
      distance: json["distance"],
      apto_inundaciones: json["apto_inundaciones"],
      apto_terremoto: json["apto_terremoto"],
      city_id: json["city_id"],
      contact_name: json["contact_name"],
      contact_phone_number: json["contact_phone_number"],
      created_at: json["created_at"],
      current_number_of_people: json["current_number_of_people"],
      geolocation_id: json["geolocation_id"],
      iso_code: json["iso_code"],
      max_capacity: json["max_capacity"],
      province_id: json["province_id"],
      tipo: json["tipo"],
      updated_at: json["updated_at"],
      provinceName: json["provinceName"],
    );
  }

  toJson() {}
}
