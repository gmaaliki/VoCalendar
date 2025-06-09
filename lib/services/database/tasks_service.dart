import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tasks.model.dart';

class TasksService {
  final _tasksRef = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await _tasksRef.add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _tasksRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }

  Stream<List<Task>> getTasksForUser(String userId) {
    return _tasksRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Task.fromDocument(doc)).toList());
  }
}
