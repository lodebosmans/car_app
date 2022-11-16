import 'package:car_app/pages/list.dart';
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
        child: PersonalCarList(
          name: userName1,
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    init();
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
    if (count == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Seems that you don\'t have any cars rated yet'),
          ElevatedButton(
            child: const Text('Go to scanpage'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScanPage())),
          ),
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
                  Text(carList[position].userScores[0].userName.toString().capitalize()),
                  Text(carList[position].userScores[0].scoreNumber.toString()),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
