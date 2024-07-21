import 'package:flutter/material.dart';
import 'package:flutter_contact_firebase/widgets/button_widget.dart';
import '../../models/sql_model.dart';
import '../../widgets/default_text_field.dart';

class AddTaskLocal extends StatefulWidget {
  final SQLModel? todo;
  final ValueChanged<Map<String, String>> onSubmit;
  const AddTaskLocal({
    super.key,
    this.todo,
    required this.onSubmit,
  });

  @override
  State<AddTaskLocal> createState() => _AddTaskLocalState();
}

class _AddTaskLocalState extends State<AddTaskLocal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
              height: 35,
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
                      final name = _nameController.text;
                      final mobile = _mobileController.text;
                      final email = _emailController.text;
                      widget.onSubmit({
                        'name': name,
                        'mobile': mobile,
                        'email' : email,
                      });
                    },
                    child: const ButtonWidget(
                      title: "Add",
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
