import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../connection/ogg_config.dart';
import 'ogg_form_dialog.dart';

class connectionDrawer extends StatelessWidget {
  final Box<OggConfig> connectionsBox;
  final Function() refreshUI;

  final TextEditingController serverController = TextEditingController();
  final TextEditingController deploymentController = TextEditingController();
  final TextEditingController protocolController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  connectionDrawer({
    Key? key,
    required this.connectionsBox,
    required this.refreshUI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OggConfig> connections = connectionsBox.values.toList();
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: connectionsBox.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitle: Row(
                    children: [
                      Text(
                          "${connections[index].server}\n(Port: ${connections[index].port})"),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showFormDialog(
                            context,
                            connectionsBox.get(index),
                            index,
                            serverController,
                            deploymentController,
                            portController,
                            usernameController,
                            passwordController,
                            (OggConfig updatedConfig, int idx) {
                              if (idx == -1) {
                                connectionsBox.add(updatedConfig);
                              } else {
                                connectionsBox.putAt(idx, updatedConfig);
                              }
                              clearControllers();
                              refreshUI();
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Connection was deleted'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      connectionsBox.deleteAt(index);
                                      refreshUI();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        onPressed: () {
                          final key = connectionsBox.keyAt(index);
                          final current = connectionsBox.get(key);
                          if (current != null) {
                            current.active = !current.active;
                            current.save();
                            String visible =
                                current.active ? "visible" : "not visible";
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Connection is $visible'),
                                );
                              },
                            );
                            refreshUI();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showFormDialog(
                      context,
                      null,
                      -1,
                      serverController,
                      deploymentController,
                      portController,
                      usernameController,
                      passwordController,
                      (OggConfig updatedConfig, int idx) {
                        if (idx == -1) {
                          connectionsBox.add(updatedConfig);
                        } else {
                          connectionsBox.putAt(idx, updatedConfig);
                        }
                        clearControllers();
                        refreshUI();
                      },
                    );
                  },
                ),
              ),
              Text('Configuration'),
            ],
          ),
        ],
      ),
    );
  }

  void clearControllers() {
    serverController.clear();
    deploymentController.clear();
    protocolController.clear();
    portController.clear();
    usernameController.clear();
    passwordController.clear();
  }
}
