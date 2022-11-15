class Car {
  String carBrand;
  int maxSpeed;
  int numberOfSeats;

  Car(
      {required this.carBrand,
      required this.maxSpeed,
      required this.numberOfSeats});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carBrand: json['carBrand'],
      maxSpeed: json['maxSpeed'],
      numberOfSeats: json['numberOfSeats'],
    );
  }

  Map<String, dynamic> toJson() => {
        'carbrand': carBrand,
        'maxSpeed': maxSpeed,
        'numberOfSeats': numberOfSeats,
      };
}
