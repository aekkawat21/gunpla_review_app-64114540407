import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'member';  // ค่าเริ่มต้นเป็น "member"

  void _register() async {
    final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app');  // URL ของ PocketBase server

    try {
      final newUser = await pb.collection('users_duplicate').create(body: {
        'email': _emailController.text,
        'password': _passwordController.text,
        'passwordConfirm': _passwordController.text,
        'name': _nameController.text,
        'role': _role,  // ส่งค่า role เป็น "member" หรือ "admin"
      });

      print('User created: $newUser');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Registration Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _role,
              items: ['member', 'admin'].map((String value) {  // ตัวเลือก role
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _role = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
