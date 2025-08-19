import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_link/model/announcement_model.dart';

class AnnouncementService {
  final _db = FirebaseFirestore.instance;

  // Create Announcement
  Future<void> addAnnouncement(AnnouncementModel announcement)async{
    try{
    await _db.collection('announcements').doc(announcement.announcementId).set(announcement.toMap());
    }catch(e){
      throw Exception("Error in adding announcement: $e");
    }
  }

  // View Announcement
//   Future<List<AnnouncementModel>> getAnnouncements(String adminId) async {
//   try {
//     final snapshot = await _db
//         .collection('announcements')
//         .where('admin_id', isEqualTo: adminId)
//         .get();

//     return snapshot.docs
//         .map((doc) => AnnouncementModel.fromMap(doc.data()))
//         .toList();
//   } catch (e) {
//     throw Exception("Error in fetching announcements: $e");
//   }
// }

  Future<List<AnnouncementModel>> getAnnouncements(String userId,role) async {
  try {
    String adminId = "";
    if(role == "admin"){
      adminId = userId;
    }else if(role == "teacher"){
      final teacherDoc = await _db.collection("teachers").doc(userId).get();
      adminId = teacherDoc.data()?["admin_id"];
      if(adminId == null)throw Exception("Admin not found for teacher");
    }else if(role == "student"){
      final studentDoc = await _db.collection("students").doc(userId).get();
      adminId = studentDoc.data()?["admin_id"];
      if(adminId == null)throw Exception("Admin not found for student");
    }else{
      throw Exception("Invalid role");
    }
    final snapshot = await _db
        .collection('announcements')
        .where('admin_id', isEqualTo: adminId)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromMap(doc.data()))
        .toList();
  } catch (e) {
    throw Exception("Error in fetching announcements: $e");
  }
}

  // Update Announcement
  Future<void> updateAnnouncements(AnnouncementModel announcement)async{
    try{
    await _db.collection('announcements').doc(announcement.announcementId).update(announcement.toMap());
    }catch(e){
      throw Exception("Error in updating announcement: $e");
    }
  }

  // Delete Announcement
  Future<void> deleteAnnouncements(String announcementId)async{
    try{
    await _db.collection('announcements').doc(announcementId).delete();
    }catch(e){
      throw Exception("Error in deleting announcement: $e");
    }
  }
}