import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // สำหรับการเลือกภาพ
import 'package:http/http.dart' as http; // สำหรับทำงานกับการอัปโหลดไฟล์
import 'dart:io'; // สำหรับไฟล์
import 'package:pocketbase/pocketbase.dart';

class CreateGunplaPage extends StatefulWidget {
  @override
  _CreateGunplaPageState createState() => _CreateGunplaPageState();
}

class _CreateGunplaPageState extends State<CreateGunplaPage> {
  final _modelNameController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedGrade;  // เก็บค่าที่เลือกของ Grade
  String? _selectedScale;  // เก็บค่าที่เลือกของ Scale
  File? _selectedImage;    // เก็บไฟล์รูปภาพที่เลือก

  final List<String> _grades = ['HG', 'RG', 'MG', 'PG'];  // ตัวเลือกของ Grade
  final List<String> _scales = ['1/144', '1/100', '1/60'];  // ตัวเลือกของ Scale

  final picker = ImagePicker(); // ตัวเลือกสำหรับเลือกรูปภาพ

  // ฟังก์ชันสำหรับเลือกรูปภาพจากอุปกรณ์
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // แปลงเป็นไฟล์และเก็บค่า
      });
    }
  }

  void _createGunpla() async {
    final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app'); // URL ของ PocketBase server

    try {
      // สร้างข้อมูล GUNPLA ก่อน
      final createdGunpla = await pb.collection('gunpla').create(body: {
        'title': _modelNameController.text,  // เปลี่ยนจาก 'model_name' เป็น 'title'
        'grade': _selectedGrade,  // เก็บค่า Grade ที่เลือก
        'scale': _selectedScale,  // เก็บค่า Scale ที่เลือก
        'year': _yearController.text,
        'description': _descriptionController.text,
      });

      // อัปโหลดรูปภาพถ้ามี
      if (_selectedImage != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://inspired-lenient-insect.ngrok-free.app/api/collections/gunpla/records/${createdGunpla.id}/files'),
        );
        
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // ชื่อฟิลด์ที่ตรงกับใน PocketBase
            _selectedImage!.path,
          ),
        );
        
        var res = await request.send();

        if (res.statusCode == 200) {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image');
        }
      }

      print('GUNPLA Created');
      Navigator.pushReplacementNamed(context, '/gunplaList');
    } catch (e) {
      print('Error Creating GUNPLA: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New GUNPLA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // เพิ่มการเลื่อนกรณีหน้าจอเต็ม
          child: Column(
            children: [
              TextField(
                controller: _modelNameController,
                decoration: InputDecoration(labelText: 'Model Name'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Grade'),
                value: _selectedGrade,
                items: _grades.map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGrade = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Scale'),
                value: _selectedScale,
                items: _scales.map((String scale) {
                  return DropdownMenuItem<String>(
                    value: scale,
                    child: Text(scale),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedScale = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              // ปุ่มสำหรับเลือกรูปภาพ
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an Image'),
              ),
              // แสดงตัวอย่างรูปภาพที่เลือก
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Text('No image selected.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createGunpla,
                child: Text('Create GUNPLA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
