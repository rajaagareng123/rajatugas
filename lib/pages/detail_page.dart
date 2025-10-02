import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class DetailPage extends StatefulWidget {
  final int lariId;
  const DetailPage({super.key, required this.lariId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final List<MapLatLng> _dummyRoute = const [
    MapLatLng(-6.1259787908903025, 106.9237314551548), // ppkd jakarta uatra
    MapLatLng(-6.126288150346669, 106.92375827724521), // masjid al-hikmah
    MapLatLng(-6.125719943397943, 106.92464189517248), //  smp 231
    MapLatLng(-6.125746936320273, 106.92284302709156), // PT cahaya timur urama
    MapLatLng(-6.126585941071115, 106.92177105496341,
    ), // Bengkel gubug mas agung
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  //AppBar
  AppBar _buildAppBar() {
    return AppBar(title: const Text("Detail Lari"));
  }

  //Body
  Widget _buildBody() {
    if (_dummyRoute.isEmpty) {
      return _buildEmptyState();
    }
    return _buildMap(_dummyRoute);
  }

  //Empty State
  Widget _buildEmptyState() {
    return const Center(child: Text("Belum ada data rute"));
  }

  Widget _buildMap(List<MapLatLng> route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            initialFocalLatLng: route.first,
            initialZoomLevel: 15,
            initialMarkersCount: 1,
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: route.first.latitude,
                longitude: route.first.longitude,
                child: const Icon(Icons.location_pin, color: Colors.red),
              );
            },
            sublayers: [
              MapPolylineLayer(
                polylines: {MapPolyline(points: route, color: Colors.blue)},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
