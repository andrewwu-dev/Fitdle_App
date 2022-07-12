class User {
  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;

  User([this.email, this.firstName, this.lastName, this.birthDate]);

  User.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        firstName = json["firstName"],
        lastName = json["lastName"],
        birthDate = json["birthDate"];

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "birthDate": birthDate
  };

  // FormData toJson() => FormData.fromMap({
  //   "email": email,
  //   "firstName": firstName,
  //   "lastName": lastName,
  //   "birthDate": birthDate
  // });

  update({email, firstName, lastName, birthDate}) {
    this.email ??= email;
    this.firstName ??= firstName;
    this.lastName ??=lastName;
    this.birthDate ??= birthDate;
  }
}