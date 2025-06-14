import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String id;
  String eventName;
  Timestamp startTime;
  Timestamp endTime;
  String userId;
  Timestamp createdAt;
  Timestamp updatedAt;

  Schedule({
    required this.id,
    required this.eventName,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Schedule.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Schedule(
      id: doc.id,
      eventName: data['eventName'] ?? '',
      startTime: data['startTime'] as Timestamp? ?? Timestamp.now(),
      endTime: data['endTime'] as Timestamp? ?? Timestamp.now(),
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'startTime': startTime,
      'endTime': endTime,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
        id: map['id'],
        eventName: map['eventName'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        userId: map['userId'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
    );
  }

  Schedule copyWith({
    String? id,
    String? eventName,
    Timestamp? startTime,
    Timestamp? endTime,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? userId,
  }) {
    return Schedule(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}