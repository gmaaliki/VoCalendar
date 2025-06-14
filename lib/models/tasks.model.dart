import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp createdAt;
  final Timestamp dueDate;
  final String userId;
  final List<String> labelIds;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.dueDate,
    required this.userId,
    this.labelIds = const [],
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dueDate: data['dueDate'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
      labelIds: List<String>.from(data['labelIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'userId': userId,
      'labelIds': labelIds,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    Timestamp? createdAt,
    Timestamp? dueDate,
    String? userId,
    List<String>? labelIds,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      userId: userId ?? this.userId,
      labelIds: labelIds ?? this.labelIds,
    );
  }
}
