class User {
  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;
  int? id;
  int? numPoints;

  User([this.id, this.email, this.firstName, this.lastName, this.birthDate]);

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "birthDate": birthDate
  };

  update({id, email, firstName, lastName, birthDate, numPoints}) {
    this.id ??= id;
    this.email ??= email;
    this.firstName ??= firstName;
    this.lastName ??=lastName;
    this.birthDate ??= birthDate;
    this.numPoints ??= numPoints;
  }
}