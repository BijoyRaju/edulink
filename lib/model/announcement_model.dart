
class AnnouncementModel {
  String announcementId;
  String adminId;
  String title;
  String description;

  AnnouncementModel({
    required this.announcementId,
    required this.adminId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'announcement_id' : announcementId,
      'admin_id' : adminId,
      'title' : title,
      'description' : description,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      announcementId : map["announcement_id"],
      adminId : map["admin_id"] ?? map["adminId"],
      title : map["title"],
      description : map["description"],
    );
  }
}