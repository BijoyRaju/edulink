import 'dart:convert';
import 'dart:developer';

import 'package:edu_link/model/announcement_model.dart';
import 'package:edu_link/services/announcement_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementController extends ChangeNotifier{
  final AnnouncementService _service = AnnouncementService();
  List<AnnouncementModel> announcements = [];
  bool isLoading = false;
  String? errorMessage;

  static const String _appId = "322f33fa-72f3-4bfc-a290-cbcc67cc80a7";
  static const String _restApiKey = "os_v2_app_gixth6ts6nf7ziuqzpggpteau5omafxsnczuxdvfd6xug36bkkziuipfzj7oabz7iupdm3e56pnnsfan6t3d7pslzkpka2gxbhi7ywq";


  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Fetch Announcement
  Future<void> fetchAnnouncement() async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final role = prefs.getString("role"); 

    if (userId == null ||  role == null) {
      throw Exception("User not found");
    }
    announcements = await _service.getAnnouncements(userId, role);
  } catch (e) {
    errorMessage = e.toString();
  }
  isLoading = false;
  notifyListeners();
  }


  // Create Announcement
  Future<void> addAnnouncements()async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString("userId");
      if(adminId == null){
        throw Exception("Admin not logged In");
      }
      final newAnnouncement = AnnouncementModel(
        announcementId: DateTime.now().microsecondsSinceEpoch.toString(),
        adminId: adminId,
        title: titleController.text.toString(),
        description: descriptionController.text.trim(),
      );

      await _service.addAnnouncement(newAnnouncement);
      announcements.add(newAnnouncement);
      // One Signal
      await _sendAnnouncementNotification(newAnnouncement);
      clearController();
      
    }catch(e){
      log("Error in aanouncement: $e");
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAnnouncements(AnnouncementModel announcement)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      final updated = AnnouncementModel(
        announcementId: announcement.announcementId,
        adminId: announcement.adminId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim()
      );
      await _service.updateAnnouncements(updated);
      int index = announcements.indexWhere(
        (a) => a.announcementId == updated.announcementId
      );
      if(index != -1){
        announcements[index] = updated;
      }
      clearController();
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String announcementId)async{
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      await _service.deleteAnnouncements(announcementId);
      announcements.removeWhere((a)=> a.announcementId == announcementId);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  void clearController(){
    titleController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // OneSignal Notification
    Future<void> _sendAnnouncementNotification(AnnouncementModel announcement) async {
    try {
      // final targetUserId = fee.studentId;
      final response = await http.post(
        Uri.parse("https://api.onesignal.com/notifications"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Basic $_restApiKey",
        },
        body: jsonEncode({
          "app_id": _appId,
          "included_segments": ["All"],
          // "include_external_user_ids": [targetUserId],
          "headings": {"en": "Announcement"},
          "contents": {
            "en":
                "Announcement ${announcement.title} - check for more details"
          },
        }),
      );
      
      log("OneSignal response: ${response.body}");
    } catch (e) {
      log("Error in sending Notification: $e");
    }
  }

  // For Manual announcement
  Future<void> sendPendingFeeNotificationToStudent(AnnouncementModel announcement) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.onesignal.com/notifications"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Basic $_restApiKey",
        },
        body: jsonEncode({
          "app_id": _appId,
          "included_segments": ["All"],
          "headings": {"en": "Announcement"},
          "contents": {"en": "Announcement ${announcement.title} checkout for more details"},
        }),
      );

      log("OneSignal response: ${response.body}");
    } catch (e) {
      log("Error sending notification: $e");
    }
  }


}