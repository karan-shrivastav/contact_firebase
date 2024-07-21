import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_firebase/widgets/text_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localDatabase/services/todo_functions.dart';
import '../localDatabase/widgets/add_task_widget.dart';
import '../models/sql_model.dart';
import '../widgets/add_task.dart';
import '../widgets/button_widget.dart';
import '../widgets/default_text_field.dart';
import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  static const route = '/home-screen';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int currentPageIndex = 0;

  bool isConnected = false;
  final CollectionReference _contacts =
      FirebaseFirestore.instance.collection('contacts');

  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> _create() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return const AddTask();
        });
  }

  Future<void> _createLocalData() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return AddTaskLocal(
            onSubmit: (Map<String, String> data) async {
              final name = data['name'];
              final mobile = data['mobile'];
              final email = data['email'];
              await todoDB.create(
                name: name ?? '',
                mobile: mobile ?? '',
                email: email ?? '',
              );
              if (!mounted) return;
              fetchTodos();
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _mobileController.text = documentSnapshot['mobile'].toString();
      _emailController.text = documentSnapshot['email'];
    }
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30,
                bottom: 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    controller: _nameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    maxLength: 10,
                    textInputType: TextInputType.number,
                    controller: _mobileController,
                    hintText: 'Mobile',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const ButtonWidget(
                            titleColor: Color(0xFF7c7a95),
                            color: Color(0xFFefeff9),
                            title: "Cancel",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final String name = _nameController.text;
                            final String mobile = _mobileController.text;
                            final String email = _emailController.text;
                            if (name != null) {
                              await _contacts.doc(documentSnapshot!.id).update({
                                "name": name,
                                "mobile": mobile,
                                "email": email,
                              });
                              setState(() {

                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const ButtonWidget(
                            title: 'Update',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _updateLocalData(
      int id, String? title, String? description, String? email) async {
    _nameController.text = title ?? '';
    _mobileController.text = description ?? '';
    _emailController.text = email ?? '';
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30,
                bottom: 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    controller: _nameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    maxLength: 10,
                    textInputType: TextInputType.number,
                    controller: _mobileController,
                    hintText: 'Mobile',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const ButtonWidget(
                            titleColor: Color(0xFF7c7a95),
                            color: Color(0xFFefeff9),
                            title: "Cancel",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          final String name = _nameController.text;
                          final String mobile = _mobileController.text;
                          final String email = _emailController.text;
                          todoDB.update(
                              id: id, name: name, mobile: mobile, email: email);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: const ButtonWidget(
                          title: "Update",
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _contacts.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a contact'),
      ),
    );
  }

  Future<void> _deleteFavorite(String productId) async {
    await _favorites.doc(productId).delete();
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
    fetchTodos();
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

  Future<List<SQLModel>>? futureTodos;
  List<SQLModel> favoriteList = [];
  List<SQLModel> filteredFavoriteList = [];

  final todoDB = TodoFunctions();

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  Future<void> _toggleFavorite(DocumentSnapshot documentSnapshot) async {
    final name = documentSnapshot['name'].toString();
    final mobile = documentSnapshot['mobile'].toString();
    final email = documentSnapshot['email'].toString();

    final querySnapshot = await _favorites.where('name', isEqualTo: name).get();
    if (querySnapshot.docs.isEmpty) {
      // Item is not in favorites, add it
      await _favorites.add({
        "name": name,
        "mobile": mobile,
        "email": email,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
        ),
      );
    } else {
      await _favorites.doc(querySnapshot.docs.first.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
        ),
      );
    }
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

  void _addToFavorites(SQLModel todo) {
    setState(() {
      if (!favoriteList.any((item) => item.id == todo.id)) {
        favoriteList.add(todo);
      }
    });
    print('Updated Favorite List: $favoriteList');
  }

  @override
  Widget build(BuildContext context) {
    fetchTodos();
    if (_connectionStatus == ConnectivityResult.none) {
      isConnected = false;
      print('Not connected');
    } else {
      isConnected = true;
      print('Connected');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isConnected ? 'Firebase Lists' : "Local database lists",
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.contact_phone),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
      body: <Widget>[
        isConnected
            ? StreamBuilder(
                stream: _contacts.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
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
                        final bool isFavorite = streamSnapshot.data!.docs.any(
                            (doc) => doc['name'] == documentSnapshot['name']);
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _update(streamSnapshot.data!.docs[index]);
                                },
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _toggleFavorite(documentSnapshot);
                                },
                                backgroundColor: const Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.favorite,
                                label: 'Add to Favorites',
                              ),
                            ],
                          ),
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
            : FutureBuilder<List<SQLModel>>(
                future: futureTodos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data != null) {
                      final todos = snapshot.data!;
                      return todos.isEmpty
                          ? const Center(
                              child: Text(
                                'No contacts available.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                return Slidable(
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _updateLocalData(
                                            todo.id ?? 0,
                                            todo.name,
                                            todo.mobile,
                                            todo.email,
                                          );
                                        },
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _addToFavorites(todo);
                                        },
                                        backgroundColor:
                                            const Color(0xFF7BC043),
                                        foregroundColor: Colors.white,
                                        icon: Icons.favorite,
                                        label: 'Add to Favorites',
                                      ),
                                    ],
                                  ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const TextWidget(
                                                      text: 'Delete',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      await todoDB
                                                          .delete(todo.id ?? 0);
                                                      fetchTodos();
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pop();
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
                    } else {
                      return const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
        FavoriteScreen(
          favoriteList: favoriteList,
        ),
      ][currentPageIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () async {
            if (isConnected) {
              _create();
            } else {
              _createLocalData();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
