import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handson14ott/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'HandsOn',
      home: HandsOn(),
    );
  }
}

class HandsOn extends StatefulWidget {
  const HandsOn({Key? key}) : super(key: key);

  @override
  _HandsOnState createState() => _HandsOnState();
}

class _HandsOnState extends State<HandsOn> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    super.initState();
  }

  void _goToChatPage() {
    // GETX NAVIGATION
    Get.to(() => const ChatPage());

    // STANDARD NAVIGATION - NON SI FA!!!
    // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChatPage()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(hintText: 'Cognome'),
              ),
              Row(
                children: const [
                  Text('MODERATOR: '),
                  Icon(Icons.check_box_outline_blank),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToChatPage,
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
