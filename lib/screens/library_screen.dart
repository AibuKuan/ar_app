import 'dart:convert';

import 'package:ar_app/models/equipment.dart';
import 'package:ar_app/utils/asset.dart';
import 'package:ar_app/widgets/equipment_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LibraryScreen extends StatefulWidget {
    const LibraryScreen({super.key});

    @override
    State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
    List<Equipment> equipments = [];
    // Equipment dummy = Equipment("Dummy", "assets/models/ambu-bag.glb", "dummy", "dummy", "dummy", "dummy", "dummy", "dummy");
    
    @override
    void initState() {
        super.initState();
        _loadManifest().whenComplete(() => setState(() {}));
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Column(
                children: [
                    Text("Library Screen"),
                    for (var equipment in equipments)
                        EquipmentRow(equipment: equipment),
                    // EquipmentRow(equipment: ),
                ],
            )
        );
    }

    Future<void> _loadManifest() async {
        final manifest = jsonDecode(await rootBundle.loadString('AssetManifest.json'));

        final descriptionFiles = manifest.keys.where((path) => path.startsWith('assets/descriptions/') && path.endsWith('.json')).toList();

        equipments = [];
        for (var file in descriptionFiles) {
            equipments.add(Equipment.fromJson(await loadJsonAsset(file)));
        }
    }
}