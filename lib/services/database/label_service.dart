import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapi/models/label.dart';

class LabelService {
  final CollectionReference _labelsCollection = FirebaseFirestore.instance
      .collection('labels');

  Stream<List<Label>> getLabelsForUser(String userId) {
    return _labelsCollection.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Label.fromDocument(doc)).toList();
      },
    );
  }

  // Ubah return type menjadi Future<DocumentReference>
  Future<DocumentReference> addLabel(Label label) {
    return _labelsCollection.add(label.toMap());
  }

  Future<void> updateLabel(Label label) {
    return _labelsCollection.doc(label.id).update(label.toMap());
  }

  Future<void> deleteLabel(String labelId) {
    return _labelsCollection.doc(labelId).delete();
  }
}
