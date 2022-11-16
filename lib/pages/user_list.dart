// import 'package:car_app/pages/list.dart';
import 'dart:async';
import 'dart:io';

import 'package:car_app/pages/scan.dart';
import 'package:flutter/material.dart';
import '../pages/rating.dart';
import '../apis/car_api.dart';
import '../models/personalCar.dart';
import '../utils/user_secure_storage.dart';
import '../utils/capitalize.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => UserListPageState();
}

class UserListPageState extends State {
  String userName1 = '';

  UserListPageState();
  @override
  void initState() {
    super.initState();
    init();
  }

  //get the username fro localstorage and save it in the variable userName1
  Future init() async {
    final name = await UsersecureStorage.getUserName() ?? '';
    setState(() {
      userName1 = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName1\'s rated carlist'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        //call the personal car list from the logged in user. because name is required in PersonalCarlist
        // we pass userName1 to PerosnalCarList
        child: PersonalCarList(
          name: userName1,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PersonalCarList extends StatefulWidget {
  String name;

  PersonalCarList({super.key, required this.name});

  @override
  PersonalCarListState createState() {
    return PersonalCarListState();
  }
}

class PersonalCarListState extends State<PersonalCarList> {
  List<PersonalCar> carList = [];
  int count = 0;
  // het vraagteken wil zeggen dat de peronalcarlist leeg kan zijn
  PersonalCarList? cars;
  late String name = widget.name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future init() async {
    final userName2 = await UsersecureStorage.getUserName() ?? '';
    setState(() {
      name = userName2;
      _getPersonalCars();
    });
  }

  void _getPersonalCars() {
    CarApi.fetchPersonalCars(name).then((result) {
      setState(() {
        carList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0 && isLoading) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text('Loading your carlist'),
          Text('Please wait')
        ],
      ));
    } else {
      if (count == 0) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Seems that you don\'t have any cars rated yet.'),
            Text('Click on the Scan tab in the navigation bar below.')
            // ElevatedButton(
            //   child: const Text('Go to scanpage'),
            //   onPressed: () => Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => const ScanPage())),
            // ),
          ],
        ));
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            var brand = carList[position].carBrand;
            List userScores = [];
            userScores.add(carList[position].userScores[0].userName);
            Image image;
            return Card(
              color: const Color.fromARGB(255, 227, 234, 233),
              elevation: 2.0,
              //Gesturedetector zorgt ervoor dat je de ontap methode kan gebruiken
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RatingPage(
                                carBrand: brand,
                                userScores: userScores,
                              )));
                },
                child: Column(
                  children: [
                    image = Image(
                      image: AssetImage('assets/$brand.png'),
                      width: 315,
                      height: 110,
                    ),
                    Text(carList[position].carBrand.capitalize()),
                    Text(
                        'Rating: ${carList[position].userScores[0].scoreNumber}/10'),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }
}
