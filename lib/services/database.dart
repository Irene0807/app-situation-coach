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


// 詳細debug版本的code 要用嗎?

/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Custom exception wrapper for database errors
class DatabaseException implements Exception {
  final String message;
  final dynamic original;

  DatabaseException(this.message, [this.original]);

  @override
  String toString() => 'DatabaseException: $message ${original ?? ''}';
}

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool debug;

  /// Create the service. Set debug=false to disable debug logs.
  DatabaseService({this.debug = true});

  void _log(String message) {
    if (debug) {
      final time = DateTime.now().toIso8601String();
      debugPrint('[DatabaseService] $time - $message');
    }
  }

  void _logError(String tag, dynamic error, StackTrace? st) {
    if (debug) {
      final time = DateTime.now().toIso8601String();
      debugPrint('[DatabaseService] $time - ERROR in $tag: $error');
      if (st != null) debugPrint(st.toString());
    }
  }

  void _validatePathSegments(List<String> pathSegments, {required bool mustEndWithCollection}) {
    if (pathSegments.isEmpty) {
      throw ArgumentError('pathSegments must not be empty.');
    }
    if (pathSegments.any((s) => s.trim().isEmpty)) {
      throw ArgumentError('pathSegments must not contain empty segments.');
    }
    final isCollectionPath = pathSegments.length % 2 == 1;
    if (mustEndWithCollection && !isCollectionPath) {
      throw ArgumentError('pathSegments must have odd length (collection/doc/collection/.../collection).');
    }
    if (!mustEndWithCollection && isCollectionPath) {
      throw ArgumentError('pathSegments must have even length (collection/doc/.../doc) to reference a document.');
    }
  }

  /// --------------------------------------------
  /// 泛用：取得任意層 collection reference
  /// pathSegments 例: ['users','user123','journeys','journeyA','scenes']
  /// ※ pathSegments length 必須為奇數（以 collection 結尾）
  /// --------------------------------------------
  CollectionReference getCollection(List<String> pathSegments, {bool rethrowError = false}) {
    final stopwatch = Stopwatch()..start();
    _log('getCollection called with pathSegments=${pathSegments.join('/')}');
    try {
      _validatePathSegments(pathSegments, mustEndWithCollection: true);

      CollectionReference col = _firestore.collection(pathSegments[0]);
      for (int i = 1; i < pathSegments.length; i += 2) {
        final docId = pathSegments[i];
        final nextCollectionName = pathSegments[i + 1];
        col = col.doc(docId).collection(nextCollectionName);
      }

      stopwatch.stop();
      _log('getCollection success (${stopwatch.elapsedMilliseconds}ms) -> ${pathSegments.join('/')}');
      return col;
    } on ArgumentError catch (e, st) {
      _logError('getCollection', e, st);
      if (rethrowError) rethrow;
      throw DatabaseException('Invalid pathSegments for getCollection: ${e.message}', e);
    } catch (e, st) {
      _logError('getCollection', e, st);
      if (rethrowError) rethrow;
      throw DatabaseException('Failed to build collection reference', e);
    }
  }

  /// --------------------------------------------
  /// 取得任意 document
  /// ※ pathSegments length 必須為偶數 (collection/doc/.../doc)
  /// --------------------------------------------
  Future<Map<String, dynamic>?> getDocument(List<String> pathSegments, {bool rethrowError = false, bool swallowErrors = false}) async {
    final stopwatch = Stopwatch()..start();
    _log('getDocument called with pathSegments=${pathSegments.join('/')}');
    try {
      _validatePathSegments(pathSegments, mustEndWithCollection: false);

      final docRef = _firestore.doc(pathSegments.join('/'));
      final snapshot = await docRef.get();
      stopwatch.stop();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.data() as Map<String, dynamic>);
        if (!data.containsKey('id')) data['id'] = docRef.id;
        _log('getDocument success (${stopwatch.elapsedMilliseconds}ms) -> ${docRef.path}');
        return data;
      } else {
        _log('getDocument: document does not exist -> ${docRef.path}');
        return null;
      }
    } on ArgumentError catch (e, st) {
      _logError('getDocument', e, st);
      if (swallowErrors) return null;
      if (rethrowError) rethrow;
      throw DatabaseException('Invalid pathSegments for getDocument: ${e.message}', e);
    } on FirebaseException catch (e, st) {
      _logError('getDocument', e, st);
      if (swallowErrors) return null;
      if (rethrowError) rethrow;
      throw DatabaseException('Firestore error getting document', e);
    } catch (e, st) {
      _logError('getDocument', e, st);
      if (swallowErrors) return null;
      if (rethrowError) rethrow;
      throw DatabaseException('Unexpected error in getDocument', e);
    }
  }

  /// --------------------------------------------
  /// 設定任意 document (merge 可選)
  /// --------------------------------------------
  Future<void> setDocument(List<String> pathSegments, Map<String, dynamic> data, {bool merge = true, bool rethrowError = false, bool swallowErrors = false}) async {
    final stopwatch = Stopwatch()..start();
    _log('setDocument called with pathSegments=${pathSegments.join('/')} merge=$merge dataKeys=${data.keys}');
    try {
      _validatePathSegments(pathSegments, mustEndWithCollection: false);

      final docRef = _firestore.doc(pathSegments.join('/'));
      await docRef.set(data, SetOptions(merge: merge));
      stopwatch.stop();
      _log('setDocument success (${stopwatch.elapsedMilliseconds}ms) -> ${docRef.path}');
    } on ArgumentError catch (e, st) {
      _logError('setDocument', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw DatabaseException('Invalid pathSegments for setDocument: ${e.message}', e);
    } on FirebaseException catch (e, st) {
      _logError('setDocument', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw DatabaseException('Firestore error setting document', e);
    } catch (e, st) {
      _logError('setDocument', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw DatabaseException('Unexpected error in setDocument', e);
    }
  }

  /// --------------------------------------------
  /// 取得 collection 下所有 document
  /// --------------------------------------------
  Future<List<Map<String, dynamic>>> getCollectionDocs(List<String> pathSegments, {bool rethrowError = false, bool swallowErrors = false}) async {
    final stopwatch = Stopwatch()..start();
    _log('getCollectionDocs called with pathSegments=${pathSegments.join('/')}');
    try {
      final colRef = getCollection(pathSegments, rethrowError: rethrowError);
      final snapshot = await colRef.get();
      final result = snapshot.docs.map((doc) {
        final map = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
        if (!map.containsKey('id')) map['id'] = doc.id;
        return map;
      }).toList();
      stopwatch.stop();
      _log('getCollectionDocs success (${stopwatch.elapsedMilliseconds}ms) -> ${pathSegments.join('/')} (${result.length} docs)');
      return result;
    } on DatabaseException catch (e, st) {
      _logError('getCollectionDocs', e, st);
      if (swallowErrors) return <Map<String, dynamic>>[];
      if (rethrowError) rethrow;
      throw;
    } catch (e, st) {
      _logError('getCollectionDocs', e, st);
      if (swallowErrors) return <Map<String, dynamic>>[];
      if (rethrowError) rethrow;
      throw DatabaseException('Failed to get collection documents', e);
    }
  }

  /// --------------------------------------------
  /// 設定 collection 下所有 document (merge 可選)
  /// - 使用 batch commit（每 batch 約 450 筆）以避免超過寫入上限
  /// --------------------------------------------
  Future<void> setAllDocsInCollection(List<String> pathSegments, List<Map<String, dynamic>> docsData, {bool merge = true, bool rethrowError = false, bool swallowErrors = false}) async {
    final stopwatch = Stopwatch()..start();
    _log('setAllDocsInCollection called with pathSegments=${pathSegments.join('/')} docsToWrite=${docsData.length} merge=$merge');
    try {
      final colRef = getCollection(pathSegments, rethrowError: rethrowError);

      if (docsData.isEmpty) {
        _log('setAllDocsInCollection: docsData is empty, nothing to do.');
        return;
      }

      WriteBatch batch = _firestore.batch();
      int ops = 0;

      for (var docData in docsData) {
        if (docData is! Map<String, dynamic>) {
          _log('Skipping invalid docData (not a Map): $docData');
          continue;
        }
        String docId;
        if (docData.containsKey('id')) {
          docId = docData['id'].toString();
        } else {
          docId = colRef.doc().id;
          docData['id'] = docId;
        }

        final docRef = colRef.doc(docId);
        batch.set(docRef, docData, SetOptions(merge: merge));
        ops++;

        // commit every 450 ops to avoid hitting limits (max 500)
        if (ops >= 450) {
          await batch.commit();
          _log('Committed a batch of $ops writes.');
          batch = _firestore.batch();
          ops = 0;
        }
      }

      if (ops > 0) {
        await batch.commit();
        _log('Committed remaining batch of $ops writes.');
      }

      stopwatch.stop();
      _log('setAllDocsInCollection success (${stopwatch.elapsedMilliseconds}ms) -> ${pathSegments.join('/')}');
    } on DatabaseException catch (e, st) {
      _logError('setAllDocsInCollection', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw;
    } on FirebaseException catch (e, st) {
      _logError('setAllDocsInCollection', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw DatabaseException('Firestore error in setAllDocsInCollection', e);
    } catch (e, st) {
      _logError('setAllDocsInCollection', e, st);
      if (swallowErrors) return;
      if (rethrowError) rethrow;
      throw DatabaseException('Unexpected error in setAllDocsInCollection', e);
    }
  }
}

*/