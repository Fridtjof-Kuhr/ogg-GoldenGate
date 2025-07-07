import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'connection/ogg_config.dart';
import 'connection/operation_utils.dart';
import 'widgets/ogg_monitor.dart';
import 'widgets/connection_drawer.dart';
import 'secure_storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(OggConfigAdapter());
  final key = await getEncryptionKey();
  await Hive.openBox<OggConfig>(
    'connections',
    encryptionCipher: HiveAesCipher(key),
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const GoldenGateApp());
}

class GoldenGateApp extends StatelessWidget {
  const GoldenGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController serverController = TextEditingController();
  final TextEditingController deploymentController = TextEditingController();
  final TextEditingController protocolController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Box<OggConfig> connectionsBox = Hive.box<OggConfig>('connections');

  Timer? _monitorRefreshTimer;

  @override
  void initState() {
    super.initState();
    _monitorRefreshTimer = Timer.periodic(Duration(seconds: 90), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _monitorRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<OggConfig> connections = connectionsBox.values.toList();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Cycles.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: OggMonitor(connectionsBox: connectionsBox),
      ),
      appBar: AppBar(title: Text('GoldenGate')),
      drawer: connectionDrawer(
        connectionsBox: connectionsBox,
        refreshUI: () => setState(() {}),
      ),
    );
  }
}
