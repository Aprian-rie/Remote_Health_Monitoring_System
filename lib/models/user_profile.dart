class UserProfile {
  String? uid;
  String? firstName;
  String? lastName;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    firstName = json['firstname'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstName;
    data['lastName'] = lastName;
    data['uid'] = uid;
    return data;
  }
}