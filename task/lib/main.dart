import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task/db/db_helper.dart';
import 'package:task/services/theme_services.dart';
import 'package:task/ui/home_page.dart';
import 'package:task/ui/theme.dart';

import 'models/analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: HomePage(),
      initialRoute: '/',
    routes: {
      '/main': (context) => HomePage(),
      '/chartPage': (context) => StatisticsPage(),
      '/login': (context) => AuthorizationPage(),
    }
    );
  }
}

class AuthorizationPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация', style: TextStyle(color: Color.fromRGBO(255,255,255,1),),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 100,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'Логин', border: OutlineInputBorder()),
              ),
            ),
            Container(
              width: 400,
              height: 100,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Пароль', border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;
                if (username == 'admin' && password == 'password') {
                  Get.off(() => HomePage());
                } else {
                  Get.snackbar('Error', 'Invalid username or password');
                }
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}

