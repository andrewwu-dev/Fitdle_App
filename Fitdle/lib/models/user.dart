class User {
  String? email;
  String? firstName;
  String? lastName;
  String? birthDate;
  int? id;
  int? numPoints;
  int? age;

  User([this.id, this.email, this.firstName, this.lastName, this.birthDate]);

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate
      };

  clear() {
    id = null;
    email = null;
    firstName = null;
    lastName = null;
    birthDate = null;
    numPoints = null;
    age = null;
  }

  update({id, email, firstName, lastName, birthDate, numPoints}) {
    this.id = id;
    this.email = email;
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.numPoints = numPoints;
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
