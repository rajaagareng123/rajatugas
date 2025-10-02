import 'dart:convert';

LariModel lariModelFromJson(String str) => LariModel.fromJson(json.decode(str));
String lariModelToJson(LariModel data) => json.encode(data.toJson());

class LariModel {
  LariModel({required this.id, required this.mulai, required this.selesai});

  int id;
  DateTime mulai;
  DateTime? selesai;

  factory LariModel.fromJson(Map<String, dynamic> json) => LariModel(
    id: json["id"],
    mulai: DateTime(json["mulai"]),
    selesai: json["selesai"] != null? DateTime.parse(json["selesai"]) : null,
    );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mulai": mulai.toIso8601String(), // to iso adaalah format tanggal dan waktu
    "selesai": selesai?.toIso8601String(), // 2025-09-30T11:32:00
  };

  Duration? get durasi => selesai?.difference(mulai);

  String get durasiFormat {
    if (durasi == null) return "-";
    final d = durasi!;
    final jam = d.inHours;
    final menit = d.inMinutes % 60; //agar menit tidak melebihi 59
    final detik = d.inSeconds % 60; // agar detik tidak melebihi 59

    if (jam > 0) return "$jam jam $menit menit $detik detik";
    if (menit > 0) return "$menit menit $detik detik";
    return "$detik detik";
  }
}
