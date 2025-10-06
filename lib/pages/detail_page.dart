import 'package:flutter/material.dart';
import 'package:running_tracker/db/database_instance.dart';
import 'package:running_tracker/model/lari_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class DetailPage extends StatefulWidget {
  final int lariId;
  const DetailPage({super.key, required this.lariId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseInstance _databaseInstance = DatabaseInstance();
  List<MapLatLng> _route = [];
  LariModel? _lari;
  bool _loading = true;

  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final detail = await _databaseInstance.getDetailLari(widget.lariId);
    final allLari = await _databaseInstance.getAllLari();
    final lari = allLari.firstWhere((e) => e.id == widget.lariId);

    setState(() {
      _route = detail;
      _lari = lari;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Mulai Lari")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SfMaps(
                layers: [
                  MapTileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    initialZoomLevel: 15,
                    initialFocalLatLng: _route.isNotEmpty
                        ? _route.first
                        : const MapLatLng(
                            -6.125591842330566,
                            106.92389269824174,
                          ),
                    initialMarkersCount: _route.isNotEmpty ? 2 : 0,
                    markerBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        //titik awal
                        return MapMarker(
                          latitude: _route.first.latitude,
                          longitude: _route.first.longitude,
                          child: const Icon(
                            Icons.flag,
                            color: Colors.green,
                            size: 30,
                          ),
                        );
                      } else {
                        //titik akhir
                        return MapMarker(
                          latitude: _route.first.latitude,
                          longitude: _route.first.longitude,
                          child: const Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: 30,
                          ),
                        );
                      }
                    },
                    sublayers: [
                      MapPolylineLayer(
                        polylines: {
                          MapPolyline(
                            points: _route,
                            color: Colors.red,
                            width: 3,
                          ),
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Waktu Mulai:"),
                Text(
                  _lari!.mulai.toLocal().toString().substring(11, 16),
                ), //"2025-10-03 13:30:00.00"
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Waktu Selesai:"),
                Text(
                  _lari!.selesai?.toLocal().toString().substring(11, 16) ?? "-",
                ), //null-colescing, kalau semua ini null
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Durasi"), Text(_lari!.durasiFormat)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Titik:"), Text("${_route.length}")],
            ),
          ],
        ),
      ),
    );
  }
}
