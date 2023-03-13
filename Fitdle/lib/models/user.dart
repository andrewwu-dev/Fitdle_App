class User {
  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;
  int? id;
  int? numPoints;
  int? age;
  int? bodyWeight;

  User(
      [this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.bodyWeight]);

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate,
        "bodyWeight": bodyWeight
      };

  clear() {
    id = null;
    email = null;
    firstName = null;
    lastName = null;
    birthDate = null;
    numPoints = null;
    bodyWeight = null;
    age = null;
  }

  update({id, email, firstName, lastName, birthDate, numPoints, bodyWeight}) {
    this.id = id ?? this.id;
    this.email = email ?? this.email;
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.birthDate = birthDate ?? this.birthDate;
    this.numPoints = numPoints ?? this.numPoints;
    this.bodyWeight = bodyWeight ?? this.bodyWeight;
    age = (birthDate != null)
        ? calculateAge(DateTime.parse(this.birthDate!))
        : null;
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
