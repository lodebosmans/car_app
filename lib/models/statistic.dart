class Statistic {
  String userName;
  String carBrand;
  int scoreNumber;

  Statistic({
    required this.userName,
    required this.carBrand,
    required this.scoreNumber,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      userName: json['userName'],
      carBrand: json['carBrand'],
      scoreNumber: json['scoreNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'carBrand': carBrand,
      'scoreNumber': scoreNumber,
    };
  }
}
