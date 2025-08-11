class TeacherModel {
  String teacherId;
  String adminId;
  String name;
  String email;
  String phone;
  String subject;
  DateTime dateOfBirth;
  DateTime joinDate;
  String additionalInfo;

  TeacherModel({
    required this.teacherId,
    required this.adminId,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.dateOfBirth,
    required this.joinDate,
    required this.additionalInfo
  });

  Map<String, dynamic> toMap() {
    return {
      "teacher_id" : teacherId,
      "admin_id": adminId,
      "name": name,
      "email": email,
      "phone": phone,
      "subject" : subject,
      "date_of_birth" : dateOfBirth,
      "join_date" : joinDate,
      "additional_info" : additionalInfo,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      teacherId: map["teacher_id"],
      adminId: map["admin_id"],
      name: map["name"],
      email: map["email"],
      phone: map["phone"],
      subject: map["subject"],
      dateOfBirth: map["date_of_birth"],
      joinDate: map["join_date"],
      additionalInfo: map["additional_info"],
    );
  }
}