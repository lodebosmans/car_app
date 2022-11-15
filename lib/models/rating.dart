class Rating {
  String carBrand;
  List userScores;
  // String userName;

  Rating({
    required this.carBrand,
    required this.userScores,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    var uScore = [];
    if (json['userScores'] != null) {
      uScore = <UserScores>[];
      for (var e in (json['userScores'] as List)) {
        uScore.add(UserScores.fromJson(e));
      }
    }
    return Rating(
      carBrand: json['carBrand'],
      userScores: uScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'carbrand': carBrand,
        'userScores': userScores,
      };
}

class UserScores {
  String userName;
  int scoreNumber;

  UserScores({
    required this.userName,
    required this.scoreNumber,
  });

  factory UserScores.fromJson(Map<String, dynamic> json) {
    return UserScores(
      userName: json['userName'],
      scoreNumber: json['scoreNumber'],
    );
  }
}
