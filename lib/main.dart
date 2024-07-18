import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/controllers/global_controller.dart';
import '../../common/widgets/kabbee_appbar.dart';

import '../controllers/login_controller.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_screens_wrapper.dart';
import '../widgets/login/chat_button.dart';
import '../widgets/login/default_auth_options.dart';
import '../widgets/login/terms_of_use.dart';
import '../widgets/server_option.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Get.put(LoginController());

    Get.find<GlobalController>()
      ..globalContext = context
      ..globalScaffoldKey.currentState?.removeCurrentMaterialBanner();

    return AuthScreenWrapper(
      appBar: KabbeeAppBar(context, isTransparent: true, hasLeading: false),
      authForm: AuthForm(
        formKey: Get.find<LoginController>().loginFormKey,
        title: 'login'.tr,
        // subtitle: 'login_to_continue'.tr,
        subtitle:
            'Please chose one of the following  sign in methods to continue with Kabbee+'
                .tr,
        formComponents: const [
          DefaultAuthOptions(),
          ServerOption(),
        ],
        formFooter: const TermsOfUseLink(),
        floatingActionButton: const ChatButton(),
      ),
    );
  }
}
