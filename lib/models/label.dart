import 'package:cloud_firestore/cloud_firestore.dart';

class Label {
  final String id;
  final String name;
  final String color; // Menyimpan warna sebagai string hex
  final String userId;

  Label({
    required this.id,
    required this.name,
    required this.color,
    required this.userId,
  });

  factory Label.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Label(
      id: doc.id,
      name: data['name'] ?? '',
      color: data['color'] ?? '#FFFFFF', // Warna default jika tidak ada
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'color': color, 'userId': userId};
  }

  Label copyWith({String? id, String? name, String? color, String? userId}) {
    return Label(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      userId: userId ?? this.userId,
    );
  }
}
