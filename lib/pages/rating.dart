// import 'package:car_app/pages/user_list.dart';
import 'package:flutter/material.dart';
import '../apis/car_api.dart';
import '../models/rating.dart';
import 'navigation.dart';

class RatingPage extends StatefulWidget {
  final String carBrand;
  final List userScores;
  const RatingPage({Key? key, required this.carBrand, required this.userScores})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Rating? rating;
  int score = 0;
  @override
  void initState() {
    super.initState();
    if (widget.carBrand == "" || widget.userScores == []) {
      rating = Rating(carBrand: "", userScores: []);
    } else {
      _getRating(widget.carBrand, widget.userScores);
    }
  }

  void _getRating(String carBrand, List userScores) {
    CarApi.fetchRating(carBrand, userScores).then((result) => {
          setState(() {
            rating = result;
            score = result.userScores[0].scoreNumber;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Image image;

    if (rating == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // variable to store the name from the car. so we can use it to get the accompanying photo
      var i = rating!.carBrand;
      return Scaffold(
        appBar: AppBar(
          title: const Text('DetailPage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image = Image(
                //get the accompanying photo
                image: AssetImage('assets/$i.png'),
                width: 315,
                height: 110,
              ),
              Text(rating!.carBrand),
              Text(rating!.userScores[0].userName),
              Text(rating!.userScores[0].scoreNumber.toString()),
              SizedBox(
                height: 40.0,
                width: 250.0,
                child: Divider(
                  color: Colors.blue.shade500,
                ),
              ),
              const Text(
                'Use the slider to set new rating value',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900),
              ),
              Slider(
                  value: score.toDouble(),
                  min: 0.0,
                  max: 10.0,
                  onChanged: (double newValue) {
                    setState(() {
                      score = newValue.round();
                    });
                  }),
              Text(
                score.toString(),
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900),
              ),
              ElevatedButton(
                  onPressed: _updateRating, child: const Text('Update rating')),
              SizedBox(
                height: 100.0,
                width: 250.0,
                child: Divider(
                  color: Colors.blue.shade500,
                ),
              ),
              ElevatedButton(
                  onPressed: _deleteCar,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete this car')),
            ],
          ),
        ),
      );
    }
  }

  void _updateRating() {
    CarApi.updateRating(rating!.userScores[0].userName, rating!.carBrand, score)
        .then((result) {
      Navigator.pop(context, true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ));
    });
  }

  void _deleteCar() {
    CarApi.deleteCar(rating!.carBrand, rating!.userScores[0].userName)
        .then((result) {
      Navigator.pop(context, true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ));
    });
  }
}
