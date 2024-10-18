import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'edit_gunpla_page.dart'; // เพิ่มการ import
import 'gunpla_detail_page.dart'; // เพิ่มการ import สำหรับหน้า GunplaDetailPage

class GunplaListPage extends StatefulWidget {
  final String userRole; // รับ role ของผู้ใช้จากหน้าล็อกอิน
  final Function onLogout; // ฟังก์ชันออกจากระบบ

  GunplaListPage({required this.userRole, required this.onLogout});

  @override
  _GunplaListPageState createState() => _GunplaListPageState();
}

class _GunplaListPageState extends State<GunplaListPage> {
  List<RecordModel> _gunplas = [];

  @override
  void initState() {
    super.initState();
    _fetchGunplas();
  }

  void _fetchGunplas() async {
    final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app');
    try {
      final result = await pb.collection('gunpla').getList(page: 1, perPage: 50);
      setState(() {
        _gunplas = result.items;
      });
    } catch (e) {
      print('Error fetching GUNPLA data: $e');
    }
  }

  // ปรับการสร้าง URL เพื่อใช้ collectionName แทน collectionId
  String _getImageUrl(RecordModel gunpla) {
    if (gunpla.data['image'] != null && gunpla.data['image'] != "") {
      return 'https://inspired-lenient-insect.ngrok-free.app/api/files/${gunpla.collectionId}/${gunpla.id}/${gunpla.data['image']}';
    }
    return "";
  }

  void _deleteGunpla(String id) async {
    final pb = PocketBase('https://inspired-lenient-insect.ngrok-free.app');
    try {
      await pb.collection('gunpla').delete(id);
      setState(() {
        _gunplas.removeWhere((gunpla) => gunpla.id == id);
      });
      print('GUNPLA Deleted');
    } catch (e) {
      print('Error deleting GUNPLA: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUNPLA List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              widget.onLogout(); // ฟังก์ชันออกจากระบบ
            },
          )
        ],
      ),
      body: _gunplas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _gunplas.length,
              itemBuilder: (context, index) {
                final gunpla = _gunplas[index];
                final imageUrl = _getImageUrl(gunpla);
                return Card(
                  child: ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image, size: 80),
                    title: Text(gunpla.data['title'] ?? 'No Title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Grade: ${gunpla.data['grade'] ?? 'N/A'}'),
                        Text('Scale: ${gunpla.data['scale'] ?? 'N/A'}'),
                        Text('Year: ${gunpla.data['year'] ?? 'N/A'}'),
                      ],
                    ),
                    // เงื่อนไขสำหรับ Admin เท่านั้นที่เห็นปุ่ม
                    trailing: widget.userRole == 'admin'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final updatedGunpla = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditGunplaPage(gunpla: gunpla),
                                    ),
                                  );

                                  // ตรวจสอบว่ามีการแก้ไขข้อมูล GUNPLA หรือไม่
                                  if (updatedGunpla != null) {
                                    setState(() {
                                      // ค้นหาและอัปเดต Gunpla ในลิสต์
                                      int index = _gunplas.indexWhere((item) => item.id == updatedGunpla.id);
                                      if (index != -1) {
                                        _gunplas[index] = updatedGunpla; // อัปเดตข้อมูลในลิสต์
                                      }
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteGunpla(gunpla.id); // ลบ GUNPLA
                                },
                              ),
                            ],
                          )
                        : null,  // ไม่มีปุ่มแก้ไข/ลบสำหรับสมาชิกที่ไม่ใช่ admin
                    onTap: () {
                      // ไปยังหน้ารายละเอียด GUNPLA ไม่ว่าจะเป็น Admin หรือ Member
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GunplaDetailPage(gunpla: gunpla),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
