import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'Messages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerPal Bot',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogflowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = []; // To save all messages

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogflowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('PowerPal')),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black),
                  )),
                  IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is Empty');
    } else {
      //Handle user Message
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogflowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      //Handle DialogFlowtter Message
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
