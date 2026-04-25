//firebase_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to convert audio bytes to Base64 and upload to Firestore
  // This avoids the 'Upgrade Project' issue in Firebase Storage
  Future<String> uploadAudioAsBase64(Uint8List bytes, String fileName) async {
    try {
      // Step 1: Convert raw bytes to Base64 String
      String base64String = base64Encode(bytes);

      // Step 2: Upload the string to a dedicated 'audio_data' collection
      DocumentReference doc = await _firestore.collection('audio_data').add({
        'fileName': fileName,
        'encodedData': base64String,
        'fileSize': bytes.length,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Audio uploaded to Firestore successfully: ${doc.id}');
      return doc.id; // Return the Document ID to link it to the main Job
    } catch (e) {
      print('Error uploading audio: $e');
      rethrow;
    }
  }

  // Create a processing job in Firestore
  Future<String> createCloneJob({
    required String voiceDocId,
    required String songDocId,
    required int pitch,
  }) async {
    // We store references (IDs) to the audio documents instead of URLs
    DocumentReference jobDoc =
        await _firestore.collection('voice_clone_jobs').add({
      'voiceDocId': voiceDocId,
      'songDocId': songDocId,
      'pitch': pitch,
      'status': 'pending', // Status for Python server to pick up
      'outputData': null, // Where the result will be stored (as Base64)
      'createdAt': FieldValue.serverTimestamp(),
    });
    return jobDoc.id;
  }

  // Listen to job status changes in real-time
  Stream<DocumentSnapshot> watchJobProgress(String jobId) {
    return _firestore.collection('voice_clone_jobs').doc(jobId).snapshots();
  }
}
