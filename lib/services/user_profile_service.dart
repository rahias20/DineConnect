import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../models/report.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // fetch user profile data from the database
  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot userProfileSnapshot =
          await _firestore.collection('userProfiles').doc(userId).get();

      if (userProfileSnapshot.exists) {
        return UserProfile.fromMap(
            userProfileSnapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception("Error fetching user profile: $e");
    }
    return null;
  }

  // save user profile in the database
  Future<void> saveUserProfile(UserProfile userProfile) async {
    // save the user profile to the database
    await _firestore
        .collection('userProfiles')
        .doc(userProfile.userId)
        .set(userProfile.toMap());
  }

  // update user profile in the database
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection('userProfiles')
          .doc(userProfile.userId)
          .update(userProfile.toMap());
    } catch (e) {
      throw Exception("Error updating user profile: $e");
    }
  }

  // delete the user profile
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection('userProfiles').doc(userId).delete();
  }

  // select profile picture
  Future<XFile?> selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return image;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> uploadImage(File image) async {
    try {
      File file = File(image.path);

      // upload image
      String fileName = path.basename(image.path);
      Reference ref = _storage.ref().child('profileImages/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // method to report a user
  Future<void> reportUser(String reportingUserId, String reportedUserId,
      String reportReason) async {
    try {
      // create a report object with the current DateTime
      final report = Report(
        reportingUserId: reportingUserId,
        reportedUserId: reportedUserId,
        reportReason: reportReason,
        reportTime:
            DateTime.now(), // Use DateTime.now() to get the current time
      );

      // submit the report to a "reports" collection
      await _firestore.collection('reports').add(report.toMap());
    } catch (e) {
      throw Exception("Error submitting report: $e");
    }
  }
}
