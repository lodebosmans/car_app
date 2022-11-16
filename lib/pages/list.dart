import 'package:flutter/material.dart';
import '../apis/car_api.dart';
import '../models/car.dart';
import '../utils/capitalize.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All cars'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: const CarList(),
      ),
    );
  }
}

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  CarListState createState() {
    return CarListState();
  }
}

class CarListState extends State<CarList> {
  // initialize an emty carList en count variable with the value of 0
  List<Car> carList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getCars();
  }

  // get all cars and put them in the carList. set the count to the number of cars in the list
  void _getCars() {
    CarApi.fetchCars().then((result) {
      setState(() {
        carList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 4 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          Image image;
          String i = carList[position].carBrand;
          print(i);
          return Card(
            color: const Color.fromARGB(255, 227, 234, 233),
            elevation: 2.0,
            child: Column(
              children: [
                image = Image(
                  image: AssetImage('assets/$i.png'),
                  width: 315,
                  height: 110,
                ),
                Text(carList[position].carBrand.capitalize()),
                Text('Max speed: ${carList[position].maxSpeed} km/h'),
                Text('Number of seats: ${carList[position].numberOfSeats}'),
              ],
            ),
          );
        },
      );
    }
  }
}
