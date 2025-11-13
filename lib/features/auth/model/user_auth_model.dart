class UserAuthModel {
  final String id;
  final String profileImage;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneCode;
  final String phoneNumber;
  final String registerDate;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final String bloodGroup;
  final String cid;
  final String createdAt;
  final String updatedAt;
  final String userType;

  UserAuthModel({
    required this.id,
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.registerDate,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bloodGroup,
    required this.cid,
    required this.createdAt,
    required this.updatedAt,
    required this.userType,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      id: json['id'] ?? '',
      profileImage: json['profile_image'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneCode: json['phone_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      registerDate: json['register_date'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      cid: json['cid'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }
}
