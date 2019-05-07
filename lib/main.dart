import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mobx_form/form_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX Forms',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FormExample(),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample();

  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final FormStore store = FormStore();


  @override
  void initState() {
    store.setupValidations();
  }


  @override
  void dispose() {
    store.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => TextField(
                      onChanged: store.setUsername,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Pick a username',
                          errorText: store.error.username),
                    ),
              ),
              Observer(
                  builder: (_) => AnimatedOpacity(
                      child: const LinearProgressIndicator(),
                      duration: Duration(milliseconds: 300),
                      opacity: store.isUserCheckPending ? 1 : 0)),
              Observer(
                builder: (_) => TextField(
                      onChanged: store.setEmail,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          errorText: store.error.email),
                    ),
              ),
              Observer(
                builder: (_) => TextField(
                      onChanged: store.setPassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Set a password',
                          errorText: store.error.password),
                    ),
              ),
              RaisedButton(
                child: const Text('Sign up'),
                onPressed: store.validateAll,
              )
            ],
          ),
        ),
      ));
}