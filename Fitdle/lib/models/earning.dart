class Earning {
  int userID;
  String timestamp;
  int points;

  Earning(this.userID, this.timestamp, this.points);

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
        json["userID"],
        json["timestamp"],
        json["points"]
    );
  }
}