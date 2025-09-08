import 'package:cloud_firestore/cloud_firestore.dart';

// 這邊的每個function都要把debug功能做好 之後弄

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --------------------------------------------
  /// 泛用：取得任意層 collection reference
  /// pathSegments 例: ['users','user123','journeys','journeyA','scenes']
  /// --------------------------------------------
  CollectionReference getCollection(List<String> pathSegments) {
    CollectionReference? col;
    for (int i = 0; i < pathSegments.length; i++) {
      if (i % 2 == 0) {
        // 偶數 index = collection
        col = (col ?? _firestore.collection(pathSegments[i]));
      } else {
        // 奇數 index = document，下一層 collection
        col = col!.doc(pathSegments[i]).collection(pathSegments[i + 1]);
        i++; // skip next because already used
      }
    }
    return col!;
  }

  /// --------------------------------------------
  /// 取得任意 document
  /// --------------------------------------------
  Future<Map<String, dynamic>?> getDocument(List<String> pathSegments) async {
    final docRef = _firestore.doc(pathSegments.join('/'));
    final snapshot = await docRef.get();
    return snapshot.exists ? snapshot.data() : null;
  }

  /// --------------------------------------------
  /// 設定任意 document (merge 可選)
  /// --------------------------------------------
  Future<void> setDocument(List<String> pathSegments, Map<String, dynamic> data,
      {bool merge = true}) async {
    final docRef = _firestore.doc(pathSegments.join('/'));
    await docRef.set(data, SetOptions(merge: merge));
  }

  /// --------------------------------------------
  /// 取得 collection 下所有 document
  /// --------------------------------------------
  Future<List<Map<String, dynamic>>> getCollectionDocs(
      List<String> pathSegments) async {
    final colRef = getCollection(pathSegments);
    final snapshot = await colRef.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  /// --------------------------------------------
  /// 設定 collection 下所有 document (merge 可選)
  /// --------------------------------------------
  Future<void> setAllDocsInCollection(
      List<String> pathSegments, List<Map<String, dynamic>> docsData,
      {bool merge = true}) async {
    final colRef = getCollection(pathSegments);

    for (var docData in docsData) {
      // 假設每個 document 有唯一 id 欄位 'id'
      final docId = docData['id'] ?? _firestore.collection('dummy').doc().id;
      await colRef.doc(docId).set(docData, SetOptions(merge: merge));
    }
  }
}
