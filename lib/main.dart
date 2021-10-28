import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handson14ott/chat_page.dart';
import 'package:handson14ott/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await GetStorage.init();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? credentials = GetStorage().read('credentials');

    if (credentials != null) {
      final String? name = credentials['name'];
      final String? surname = credentials['surname'];
      final bool isModerator = credentials['isModerator'] ?? false;

      final AuthController authController = Get.find<AuthController>();
      authController.name = name;
      authController.surname = surname;
      authController.isModerator = isModerator;

      return const GetMaterialApp(
        title: 'HandsOn',
        home: ChatPage(),
      );
    }

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
  bool isModerator = false;

  void _checkUncheckModerator() {
    setState(() {
      isModerator = !isModerator;
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    super.initState();
  }

  void _goToChatPage() {
    if (_nameController.text != '' && _surnameController.text != '') {
      GetStorage().write(
        'credentials',
        {
          'name': _nameController.text,
          'surname': _surnameController.text,
          'isModerator': isModerator,
        },
      );

      final AuthController authController = Get.find<AuthController>();
      authController.name = _nameController.text;
      authController.surname = _surnameController.text;
      authController.isModerator = isModerator;

      // GETX NAVIGATION
      Get.to(() => const ChatPage());

      // STANDARD NAVIGATION - SCONSIGLIATO
      // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChatPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riempire nome e cognome')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                children: [
                  const Text('MODERATOR: '),
                  IconButton(
                    color: Colors.blue,
                    icon: Icon(
                      isModerator
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    onPressed: _checkUncheckModerator,
                  ),
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
