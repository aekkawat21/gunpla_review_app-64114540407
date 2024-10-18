import 'package:flutter/material.dart';

class GunplaDetailPage extends StatelessWidget {
  final dynamic gunpla;

  GunplaDetailPage({required this.gunpla});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gunpla.data['title'] ?? 'No Title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade: ${gunpla.data['grade'] ?? 'N/A'}'),
            Text('Scale: ${gunpla.data['scale'] ?? 'N/A'}'),
            Text('Year: ${gunpla.data['year'] ?? 'N/A'}'),
            SizedBox(height: 20),
            Text(gunpla.data['description'] ?? 'No Description'),
          ],
        ),
      ),
    );
  }
}
