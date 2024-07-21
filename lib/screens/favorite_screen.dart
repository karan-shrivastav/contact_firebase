import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_firebase/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sql_model.dart';

class FavoriteScreen extends StatefulWidget {
  List<SQLModel> favoriteList;
  FavoriteScreen({Key? key, required this.favoriteList}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isConnected = false;
  final CollectionReference _favorits =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> _delete(String productId) async {
    await _favorits.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a contact'),
      ),
    );
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  Future<void> _checkConnection() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(url);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while trying to make the call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      isConnected = false;
      print('Not connected');
    } else {
      isConnected = true;
      print('Connected');
    }

    return isConnected
        ? StreamBuilder(
            stream: _favorits.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!streamSnapshot.hasData ||
                  streamSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No contacts available.'),
                );
              } else {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            documentSnapshot['name'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                documentSnapshot['mobile'].toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                documentSnapshot['email'].toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          trailing: InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      title: const TextWidget(
                                        text: "Delete contact",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      content: const TextWidget(
                                        text:
                                            "Are you sure you want to delete this contact?",
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const TextWidget(
                                            text: 'Delete',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _delete(streamSnapshot
                                                .data!.docs[index].id);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          onTap: () {
                            _makePhoneCall(
                                documentSnapshot['mobile'].toString());
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )
        : ListView.builder(
            itemCount: widget.favoriteList.length,
            itemBuilder: (context, index) {
              final todo = widget.favoriteList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      todo.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.mobile ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          todo.email ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              title: const TextWidget(
                                text: "Delete contact",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              content: const Expanded(
                                child: TextWidget(
                                  text:
                                      "Are you sure you want to delete this contact?",
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const TextWidget(
                                    text: 'Delete',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    widget.favoriteList.removeAt(index);
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      _makePhoneCall(todo.mobile ?? '');
                    },
                  ),
                ),
              );
            },
          );
    ;
  }
}
