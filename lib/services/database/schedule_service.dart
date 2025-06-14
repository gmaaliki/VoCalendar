import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/schedule_model.dart';

class ScheduleService {
  final _schedulesRef = FirebaseFirestore.instance.collection('schedules');

  Future<void> addSchedule(Schedule schedule) async {
    final docRef = _schedulesRef.doc();
    final scheduleWithId = schedule.copyWith(id: docRef.id);
    await docRef.set(scheduleWithId.toMap());
  }

  Future<void> updateSchedule(Schedule schedule) async {
    // await _schedulesRef.doc(schedule.id).update(schedule.toMap());
  }

  Future<void> deleteSchedule(String id) async {
    await _schedulesRef.doc(id).delete();
  }

  Stream<List<Schedule>> getSchedulesForUser(String userId) {
    return _schedulesRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Schedule.fromDocument(doc)).toList());

    // return _schedulesRef
    //     .where('userId', isEqualTo: userId)
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .map((snapshot) {
    //   print('🔥 Firestore returned ${snapshot.docs.length} documents');
    //   for (var doc in snapshot.docs) {
    //     print('📝 Doc ID: ${doc.id}');
    //     print('📦 Data: ${doc.data()}');
    //   }
    //   return snapshot.docs
    //       .map((doc) => Schedule.fromDocument(doc))
    //       .toList();
    // });
  }
}
