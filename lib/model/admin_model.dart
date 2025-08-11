class AdminModel {
  String adminId;
  String name;
  String email;
  String phoneNo;
  String schoolName;

  AdminModel({
    required this.adminId,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.schoolName,
  });

  Map<String, dynamic> toMap() {
    return {
      "admin_id": adminId,
      "name": name,
      "email": email,
      "phone_no": phoneNo,
      "school_name": schoolName,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminId: map["admin_id"],
      name: map["name"],
      email: map["email"],
      phoneNo: map["phone"],
      schoolName: map["school_name"],
    );
  }
}
