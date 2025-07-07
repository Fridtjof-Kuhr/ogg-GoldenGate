import 'ogg_monitor.dart';
import '../connection/ogg_config.dart';
import 'package:flutter/material.dart';
import '../connection/ogg_service.dart';
import 'custom_data_cell.dart';

enum OggType { extract, replicat, distpath }

class OggListWidget extends StatelessWidget {
  final String title;
  final OggType type;
  final List<String> names;
  final OggConfig config;

  const OggListWidget(
      {super.key,
      required this.title,
      required this.type,
      required this.names,
      required this.config});

  String getTypeString() {
    switch (type) {
      case OggType.extract:
        return 'extract';
      case OggType.replicat:
        return 'replicat';
      case OggType.distpath:
        return 'distpath';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          child: Row(
            children: const [
              HeaderCell(text: 'Name'),
              HeaderCell(text: 'Status'),
              HeaderCell(text: 'Lag'),
              HeaderCell(text: 'Rate'),
            ],
          ),
        ),
        ...names.map((name) {
          final typeStr = getTypeString();

          return FutureBuilder(
            future: Future.wait([
              config.getStatusFor(typeStr, name),
              config.getLagFor(typeStr, name),
              config.getThroughputFor(typeStr, name),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Row(
                  children: const [
                    CustomDataCell(text: 'Loading...'),
                    CustomDataCell(text: 'Loading...'),
                    CustomDataCell(text: 'Loading...'),
                    CustomDataCell(text: 'Loading...'),
                  ],
                );
              }
              final data = snapshot.data!;
              return Row(
                children: [
                  CustomDataCell(text: name),
                  CustomDataCell(text: data[0]),
                  CustomDataCell(text: data[1]),
                  CustomDataCell(text: data[2]),
                ],
              );
            },
          );
        }).toList(),
      ],
    );
  }
}
