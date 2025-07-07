import 'package:flutter/material.dart';
import '../connection/ogg_config.dart';

void showFormDialog(
  BuildContext context,
  OggConfig? config,
  int index,
  TextEditingController serverController,
  TextEditingController deploymentController,
  TextEditingController portController,
  TextEditingController usernameController,
  TextEditingController passwordController,
  Function(OggConfig, int) onSave,
) {
  if (config != null) {
    serverController.text = config.server;
    deploymentController.text = config.deployment;
    portController.text = config.port;
    usernameController.text = config.username;
    passwordController.text = config.password;
  }

  bool isHttps = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('OGG Connection'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: serverController,
                    decoration: InputDecoration(
                        hintText: 'Enter the host (name or ip)'),
                  ),
                  TextField(
                    controller: deploymentController,
                    decoration: InputDecoration(
                        hintText: 'Deployment (if ReverseProxy in use)'),
                  ),
                  SwitchListTile(
                    title: Text('Use HTTPS'),
                    value: isHttps,
                    onChanged: (bool value) {
                      setState(() {
                        isHttps = value;
                      });
                    },
                    contentPadding: EdgeInsets
                        .zero, // <- This aligns the title more to the left
                  ),
                  TextField(
                    controller: portController,
                    decoration: InputDecoration(hintText: 'Enter the port'),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText: 'Enter the username'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter the password'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('abort'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              TextButton(
                child: Text('submit'),
                onPressed: () {
                  final updatedApi = OggConfig(
                    server: serverController.text,
                    deployment: deploymentController.text,
                    protocol: isHttps ? 'https' : 'http',
                    port: portController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                    active: true,
                  );

                  onSave(updatedApi, index);

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}
