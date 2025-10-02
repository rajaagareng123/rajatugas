import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:running_tracker/db/database_instance.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final DatabaseInstance _databaseInstance = DatabaseInstance();
  List<MapLatLng> _route = [];
  bool _isRunning = false;
  Timer? _timer;
  int? _lariId;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start tracking
  Future<void> _startRun() async {
    // Simpan header lari baru
    final id = await _databaseInstance.insertLari({
      "mulai": DateTime.now().toIso8601String(),
      "selesai": null,
    });
    setState(() {
      _lariId = id;
      _isRunning = true;
      _route = [];
    });

    // Mulai tracking GPS
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latlng = MapLatLng(position.latitude, position.longitude);

      if (_lariId != null) {
        await _databaseInstance.insertDetailLari({
          "lari_id": _lariId,
          "waktu": DateTime.now().toIso8601String(),
          "latitude": position.latitude,
          "longitude": position.longitude,
        });
      }

      await _databaseInstance.insertLari({
        "lari_id": _lariId,
        "latitude": position.latitude,
        "longitude": position.longitude,
      });
      setState(() {
        _route.add(latlng);
      });
    });
  }

  // Stop tracking
  Future<void> _stopRun() async {
    _timer?.cancel();
    if (_lariId != null) {
      await _databaseInstance.updateLari(_lariId!, {
        "Selesai": DateTime.now().toIso8601String(),
      });
    }

    setState(() {
      _isRunning = false;
    });

    if (mounted) Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRunning ? " sedang berlari" : "Mulai Lari"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfMaps(
              layers: [
                MapTileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  initialFocalLatLng: _route.isNotEmpty
                      ? _route.last
                      : const MapLatLng(
                          -6.125806213780367,
                          106.92399189734166,
                        ), // Lokasi PPKD
                  initialZoomLevel: 15,
                  sublayers: [
                    MapPolylineLayer(
                      polylines: {
                        MapPolyline(
                          points: _route,
                          color: Colors.blue,
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
          _isRunning
              ? ElevatedButton.icon(
                  onPressed: _stopRun,
                  icon: const Icon(Icons.stop),
                  label: const Text("Stop Lari"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                )
              : ElevatedButton.icon(
                  onPressed: _startRun,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Mulai Lari"),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
