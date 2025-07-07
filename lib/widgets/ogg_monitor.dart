import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../connection/ogg_config.dart';
import '../connection/ogg_service.dart';
import 'ogg_list_widget.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  const HeaderCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFC74634),
          border: Border.all(color: const Color(0xFFAE562C), width: 1.0),
        ),
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class OggMonitor extends StatelessWidget {
  final Box<OggConfig> connectionsBox;
  const OggMonitor({super.key, required this.connectionsBox});

  @override
  Widget build(BuildContext context) {
    final connections = connectionsBox.values.toList();
    return ListView(
      children: connections.where((c) => c.active).map((connection) {
        return ExpansionTile(
          title: Text("${connection.server} (Port: ${connection.port})"),
          children: [
            ..._buildList(connection, OggType.extract,
                connection.getUnitNames('extract'), 'Extracts'),
            ..._buildList(connection, OggType.distpath,
                connection.getUnitNames('distpath'), 'DistPaths'),
            ..._buildList(connection, OggType.replicat,
                connection.getUnitNames('replicat'), 'Replicats'),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildList(
      OggConfig config, OggType type, Future<String> future, String title) {
    return [
      FutureBuilder<String>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(title: Text('Loading $title...'));
          } else if (snapshot.hasError) {
            return ListTile(title: Text('Error loading $title'));
          } else if (snapshot.hasData) {
            final names = snapshot.data!
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            return OggListWidget(
                title: title, type: type, names: names, config: config);
          } else {
            return ListTile(title: Text('No $title data available'));
          }
        },
      ),
    ];
  }
}
