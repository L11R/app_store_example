import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_install_app/flutter_install_app.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Example App Store Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _installStatus = "Unknown";

  void _installApk() async {
    try {
      _setInstallStatus('Downloading...');
      final resp = await http.get(Uri.https('github.com',
          'TeamNewPipe/NewPipe/releases/download/v0.24.1/NewPipe_v0.24.1.apk'));
      _setInstallStatus('Downloaded!');

      _setInstallStatus('Installing...');
      await AppInstaller.installApkBytes(resp.bodyBytes, actionRequired: false);
      _setInstallStatus('Installed!');
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  String _updateStatus = "Unknown";

  void _updateApk() async {
    try {
      _setUpdateStatus('Downloading...');
      final resp = await http.get(Uri.https('github.com',
          'TeamNewPipe/NewPipe/releases/download/v0.25.0/NewPipe_v0.25.0.apk'));
      _setUpdateStatus('Downloaded!');

      _setUpdateStatus('Updating...');
      await AppInstaller.installApkBytes(resp.bodyBytes, actionRequired: false);
      _setUpdateStatus('Updated!');
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void _setInstallStatus(String status) {
    setState(() => _installStatus = status);
  }

  void _setUpdateStatus(String status) {
    setState(() => _updateStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(_installStatus),
            TextButton.icon(
              onPressed: _installApk,
              icon: const Icon(Icons.arrow_downward),
              label: const Text('Install APK (NewPipe v0.24.1)'),
            ),
            const SizedBox(height: 40),
            Text(_updateStatus),
            TextButton.icon(
              onPressed: _updateApk,
              icon: const Icon(Icons.arrow_downward),
              label: const Text('Update APK (NewPipe v0.25.0)'),
            ),
          ],
        ),
      ),
    );
  }
}
