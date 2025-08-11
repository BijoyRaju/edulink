class StudentModel {
  String studentId;
  String adminId;
  String teacherId;
  String stdClass;
  String name;
  String email;
  String parentName;
  String phone;
  String profileImage;
  String rollNo;
  DateTime dateOfBirth;
  DateTime admissionDate;

  StudentModel({
    required this.studentId,
    required this.adminId,
    required this.teacherId,
    required this.stdClass,
    required this.name,
    required this.email,
    required this.parentName,
    required this.phone,
    required this.profileImage,
    required this.rollNo,
    required this.dateOfBirth,
    required this.admissionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "student_id": studentId,
      "admin_id": adminId,
      "teacher_id" : teacherId,
      "std_class" : stdClass,
      "name": name,
      "email": email,
      "parent_name" : parentName,
      "phone": phone,
      "profile_image" : profileImage,
      "roll_no" : rollNo,
      "date_of_birth" : dateOfBirth,
      "admission_date" : admissionDate,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentId: map["student_id"],
      adminId: map["admin_id"],
      teacherId: map["teacher_id"],
      stdClass: map["std_class"],
      name: map["name"],
      email: map["email"],
      parentName: map["parent_name"],
      phone: map["phone"],
      profileImage: map["profile_image"],
      rollNo: map["roll_no"],
      dateOfBirth: map["date_of_birth"],
      admissionDate: map["admission_date"],
    );
  }
}
