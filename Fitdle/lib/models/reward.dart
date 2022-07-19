
class Reward {
  String? imgURL;
  String title;
  String? description;
  int cost;
  bool isAvailable;

  Reward(this.imgURL, this.title, this.description, this.cost, this.isAvailable);

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      json["image"],
      json["title"],
      json["description"],
      json["cost"],
      json["isAvailable"]
    );
  }
}