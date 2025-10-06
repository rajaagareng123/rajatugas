import 'dart:convert';

LariDetailModel lariDetailModelFromJson(String str) =>
    LariDetailModel.fromJson(json.decode(str));
    

String lariDetailModelToJson(LariDetailModel data) =>
    json.encode(data.toJson());

class LariDetailModel {
  LariDetailModel({
    required this.id,
    required this.lariId,
    required this.waktu,
    required this.latitude,
    required this.longitude,
  });

  int id;
  int lariId;
  String waktu;
  double latitude;
  double longitude;

  factory LariDetailModel.fromJson(Map<String, dynamic> json) =>
      LariDetailModel(
        id: json["id"],
        lariId: json["lari_id"],
        waktu: json["waktu"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lari_id": lariId,
    "waktu": waktu,
    "latitude": latitude,
    "longitude": longitude,
  };
}
