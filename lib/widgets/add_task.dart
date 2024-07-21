import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_firebase/widgets/button_widget.dart';
import 'default_text_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final CollectionReference _contacts =
      FirebaseFirestore.instance.collection('contacts');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              hintText: 'Mobile number',
            ),
            const SizedBox(
              height: 15,
            ),
            DefaultTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            const SizedBox(
              height: 25,
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
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      print('inside submit');
                      final String name = _nameController.text;
                      final String mobile = _mobileController.text;
                      final String email = _emailController.text;
                      if (name.isNotEmpty) {
                        try {
                          print('inside try');
                          await _contacts.add({
                            "name": name,
                            "mobile": mobile,
                            "email": email,
                          });
                          print('added');
                          _nameController.text = '';
                          _mobileController.text = '';
                          _emailController.text = '';
                          _statusController.text = '';
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error : $e'),
                            ),
                          );
                        }
                      }
                    },
                    child: ButtonWidget(
                      title: 'Add',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
