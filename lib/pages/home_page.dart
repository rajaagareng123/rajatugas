import 'package:flutter/material.dart';
import 'package:running_tracker/db/database_instance.dart';
import 'package:running_tracker/model/lari_model.dart';
import 'package:running_tracker/pages/create_page.dart';
import 'package:running_tracker/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseInstance _databaseInstance = DatabaseInstance();
  List<LariModel> _lariList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _databaseInstance.getAllLari();
    setState(() {
      _lariList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Running Tracker")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePage()),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: _lariList.isEmpty
          ? const Center(child: Text("Belum ada data lari"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lariList.length,
              itemBuilder: (context, index) {
                final lari = _lariList[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      "Lari${lari.mulai.toLocal().toString().substring(0, 15)}",
                    ),
                    subtitle: Text(
                      "Durasi : ${lari.durasiFormat}\nMulai: ${lari.mulai.hour}:${lari.mulai.minute}"
                      "- ${lari.selesai != null ? "${lari.selesai!.hour}:${lari.selesai!.minute}" : "-"}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(lariId: lari.id),
                          ),
                        );
                      },
                      child: const Text("Detail"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
