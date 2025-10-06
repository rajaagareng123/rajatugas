//Menu home_page
import 'package:flutter/material.dart';

import 'package:running_tracker/db/database_instance.dart';
import 'package:running_tracker/pages/create_page.dart';
import 'package:running_tracker/model/lari_model.dart';
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

  Future<void> _delete(int lariId) async {
    await _databaseInstance.hapus(lariId); // 🔥 panggil fungsi delete di DB
    setState(() {
      _lariList.removeWhere((item) => item.id == lariId); // 🔥 hapus dari list
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
                      "Lari ${lari.mulai.toLocal().toString().substring(0, 16)}",
                    ),
                    subtitle: Text(
                      "Durasi ${lari.durasiFormat}\nMulai: ${lari.mulai.hour}:${lari.mulai.minute}"
                      "- ${lari.selesai != null ? "${lari.selesai!.hour}:${lari.selesai!.minute}" : "-"}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Detail
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(lariId: lari.id),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol Delete
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            // Dialog konfirmasi
                            bool? confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text(
                                  "Yakin mau hapus data ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              _delete(lari.id)!; // 🔥 hapus data
                            }
                          },
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
