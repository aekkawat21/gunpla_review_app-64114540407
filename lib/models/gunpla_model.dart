class Gunpla {
  final String title;
  final String grade;
  final String scale;
  final String year;
  final String description;
  final String image; // เพิ่มฟิลด์สำหรับเก็บ URL รูปภาพ

  Gunpla({
    required this.title,
    required this.grade,
    required this.scale,
    required this.year,
    required this.description,
    required this.image, // เพิ่มฟิลด์ image
  });

  factory Gunpla.fromJson(Map<String, dynamic> json) {
    return Gunpla(
      title: json['title'] ?? 'N/A',  // หากไม่มีข้อมูลจะใช้ค่าเริ่มต้นเป็น 'N/A'
      grade: json['grade'] ?? 'N/A',
      scale: json['scale'] ?? 'N/A',
      year: json['year'] ?? 'N/A',
      description: json['description'] ?? 'N/A',
      image: json['image'] ?? '',  // หากไม่มีรูปภาพจะใช้ค่าเริ่มต้นเป็นค่าว่าง
    );
  }
}
