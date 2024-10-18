import 'package:flutter/material.dart';

class GunplaCard extends StatelessWidget {
  final String title;
  final String grade;
  final String scale;
  final String year;
  final String description;
  final String imageUrl; // เพิ่มฟิลด์สำหรับรูปภาพ

  GunplaCard({
    required this.title,
    required this.grade,
    required this.scale,
    required this.year,
    required this.description,
    required this.imageUrl, // รับ URL รูปภาพจากภายนอก
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: imageUrl.isNotEmpty // ตรวจสอบว่ามีรูปภาพหรือไม่
            ? Image.network(
                imageUrl, // แสดงรูปภาพจาก URL
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            : Icon(Icons.image, size: 80), // แสดงไอคอนแทนถ้าไม่มีรูปภาพ
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade: $grade'),
            Text('Scale: $scale'),
            Text('Year: $year'),
            Text('Description: $description'),
          ],
        ),
      ),
    );
  }
}
