import 'package:flutter/material.dart';

import 'api.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key,required this.api}) : super(key: key);
  final API api;
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  String loginErrorMessage = '';
  bool isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Ethio Betting Tips (Admin)')),
        body: Center(
          child: SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  (isLoggingIn)?const LinearProgressIndicator():Text(loginErrorMessage,style: const TextStyle(color: Colors.red),),
                  const Divider(color: Colors.transparent,),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoggingIn = true;
                        });
                        widget.api.logIn(emailController.value.text, passwordController.value.text).then((value) {
                          if(value != null){
                            setState(() {
                              loginErrorMessage = 'Incorrect Email/Password'; // TODO: ${value} to be used later
                              isLoggingIn = false;
                            });
                          } 
                        });
                      },
                      child: const Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Text('Login')))
                ],
              )),
        ));
  }
}
