import 'package:flutter/material.dart';

import 'api.dart';

class CreateAdminPage extends StatefulWidget {
  const CreateAdminPage({Key? key, required this.api}) : super(key: key);
  final API api;
  @override
  _CreateAdminPageState createState() => _CreateAdminPageState();
}

class _CreateAdminPageState extends State<CreateAdminPage> {
  bool isCreatingAdmin = false;
  String createAdminError = '';
  TextEditingController adminEmailController = TextEditingController(),
      adminPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Admin'),
      ),
      body: Center(
          child: SizedBox(
              height: 300,
              width: 300,
              child: Material(
                  child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: adminEmailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const Divider(color: Colors.transparent),
                    TextField(
                      controller: adminPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'password'),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      createAdminError,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const Divider(),
                    SizedBox(
                        height: 40,
                        child: (isCreatingAdmin)
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isCreatingAdmin = true;
                                    createAdminError = '';
                                  });
                                  widget.api
                                      .createAdmin(
                                          adminEmailController.value.text,
                                          adminPasswordController.value.text)
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        isCreatingAdmin = false;
                                        createAdminError = value;
                                      });
                                    } else {
                                      setState(() {
                                        isCreatingAdmin = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Admin Created')));
                                    }
                                  });
                                },
                                child: const Text('Create Admin')))
                  ],
                ),
              )))),
    );
  }
}
