import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class EditGunplaPage extends StatefulWidget {
  final RecordModel gunpla; // รับข้อมูล GUNPLA จากหน้า GunplaList

  EditGunplaPage({required this.gunpla});

  @override
  _EditGunplaPageState createState() => _EditGunplaPageState();
}

class _EditGunplaPageState extends State<EditGunplaPage> {
  final _titleController = TextEditingController();
  String? _selectedGrade; // สำหรับจัดเก็บค่าเกรดที่เลือก
  String? _selectedScale; // สำหรับจัดเก็บค่าสเกลที่เลือก
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _grades = ['HG', 'MG', 'RG', 'PG'];  // ตัวเลือกสำหรับเกรด
  final List<String> _scales = ['1/144', '1/100', '1/60']; // ตัวเลือกสำหรับสเกล

@override
void initState() {
  super.initState();
  // ตั้งค่าฟิลด์ด้วยข้อมูลที่รับมาจากหน้า GunplaList
  _titleController.text = widget.gunpla.data['title'] ?? '';
  _selectedGrade = widget.gunpla.data['grade'];  // กำหนดค่าเริ่มต้นสำหรับเกรด
  _selectedScale = widget.gunpla.data['scale'];  // กำหนดค่าเริ่มต้นสำหรับสเกล
  // ถ้า year เป็น int ต้องแปลงเป็น String ก่อน
  _yearController.text = widget.gunpla.data['year']?.toString() ?? '';
  _descriptionController.text = widget.gunpla.data['description'] ?? '';
}


void _updateGunpla() async {
  final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app');
  try {
    final updatedGunpla = await pb.collection('gunpla').update(widget.gunpla.id, body: {
      'title': _titleController.text,
      'grade': _selectedGrade,  // ส่งค่าเกรดที่เลือก
      'scale': _selectedScale,  // ส่งค่าสเกลที่เลือก
      'year': _yearController.text,
      'description': _descriptionController.text,
    });

    print('GUNPLA Updated');
    Navigator.pop(context, updatedGunpla); // ส่งข้อมูล GUNPLA ที่อัปเดตกลับไป
  } catch (e) {
    print('Error updating GUNPLA: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit GUNPLA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),

              // Dropdown สำหรับ Grade
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Grade'),
                value: _selectedGrade,  // ค่าเริ่มต้น
                items: _grades.map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGrade = newValue;  // อัปเดตค่าเกรดเมื่อผู้ใช้เลือก
                  });
                },
              ),
              SizedBox(height: 16),

              // Dropdown สำหรับ Scale
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Scale'),
                value: _selectedScale,  // ค่าเริ่มต้น
                items: _scales.map((String scale) {
                  return DropdownMenuItem<String>(
                    value: scale,
                    child: Text(scale),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedScale = newValue;  // อัปเดตค่าสเกลเมื่อผู้ใช้เลือก
                  });
                },
              ),
              SizedBox(height: 16),

              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _updateGunpla,
                child: Text('Update GUNPLA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

