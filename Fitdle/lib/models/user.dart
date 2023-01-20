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
    this.id = null;
    this.email = null;
    this.firstName = null;
    this.lastName = null;
    this.birthDate = null;
    this.numPoints = null;
    this.age = null;
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
