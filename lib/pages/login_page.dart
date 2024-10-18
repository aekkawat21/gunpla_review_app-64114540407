import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app'); // URL ของ PocketBase server

    try {
      // ฟังก์ชันนี้ใช้ authWithPassword ของระบบ auth ของ PocketBase
      final authData = await pb.collection('users_duplicate').authWithPassword(
        _emailController.text,
        _passwordController.text,
      );

      // ตรวจสอบบทบาท (role) จากข้อมูล authData
      String userRole = authData.record!.data['role'];

      // แสดง token หรือข้อมูลอื่น ๆ ที่ได้จากการ login
      print('Login Success: ${authData.token}');
      print('User Role: $userRole');

      // นำผู้ใช้ไปยังหน้า Create GUNPLA หรือ GUNPLA List ตาม role
      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(context, '/createGunpla'); // ไปหน้า Create GUNPLA สำหรับ admin
      } else if (userRole == 'member') {
        Navigator.pushReplacementNamed(context, '/gunplaList');  // ไปหน้า GUNPLA List สำหรับ member
      } else {
        // ถ้า role ไม่ตรงกับที่กำหนด
        print('Login Error: Invalid role');
      }
    } catch (e) {
      // แสดงข้อผิดพลาดถ้ามี
      print('Login Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // ซ่อนรหัสผ่าน
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, // เรียกใช้ฟังก์ชัน _login เมื่อกดปุ่ม
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
