class ProfileDetailsDB {
  int? id;
  String? fullName;
  String? eMail;
  String? phoneNumber;
  String? gender;
  String? imagex;

  ProfileDetailsDB({
    this.id,
    this.fullName,
    this.eMail,
    this.phoneNumber,
    this.gender,
    this.imagex,
  });

  static ProfileDetailsDB fromMap(Map<String, Object?> map) {
    int id = map['id'] as int;
    String fullName = map['fullname'] as String;
    String eMail = map['email'] as String;
    String phoneNumber = map['phonenumber'] as String;
    String gender = map['gender'] as String;
    String? imagex = map['imagex'] as String?;

    return ProfileDetailsDB(
     id: id,
     fullName: fullName,
     eMail: eMail,
     phoneNumber: phoneNumber,
     gender: gender,
     imagex: imagex,
     );
  }
}