import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/create_gunpla_page.dart';  // เพิ่มการ import หน้า Create GUNPLA
import 'pages/gunpla_list_page.dart'; // เพิ่มการ import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUNPLA Review App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // หน้าหลักที่มีปุ่ม Login และ Register
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/gunplaList': (context) => GunplaListPage(
              userRole: 'admin',  // กำหนด role ที่ต้องการ เช่น admin หรือ member
              onLogout: () {
                // ใส่ฟังก์ชันที่ต้องการทำงานเมื่อผู้ใช้กด Logout
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        '/createGunpla': (context) => CreateGunplaPage(),  // เพิ่มเส้นทางสำหรับหน้า Create GUNPLA
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to GUNPLA Review App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20), // เพิ่มช่องว่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
