import 'package:car_app/pages/list.dart';
import 'package:car_app/pages/login.dart';
import 'package:car_app/pages/scan.dart';
import 'package:car_app/pages/user_list.dart';
// import 'package:car_app/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<StatefulWidget> createState() => NavigationPageState();
}

class NavigationPageState extends State {
  // innitialiseren van _selectedIndex met waarde 0
  int _selectedIndex = 0;

  NavigationPageState();

  // de waarde van _selectedIndex aanpassen naar de indexwaarde van de gekozen navbar item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// initialiseren van een lijst van pagina's die later in de navbar kunnen worden opgeroepen
  final screens = [
    const UserListPage(),
    const ListPage(),
    const ScanPage(),
    const LoginPage()
  ];

  // @override
  // void initState() {
  //   super.initState();

  //   init();
  // }

  // Future init() async {
  //   final naam = await UsersecureStorage.getUserName() ?? '';

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// afhankelijk van de selected index wordt er een andere pagian opgeroepen uit de screens list
// Bij het opstarten van de app is dit de userlistpage daar deze eerst staat in de lijst en dus index 0 heeft
        body: screens[_selectedIndex],

// Navbar met 4 navbaritems
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'All cars',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adf_scanner),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightGreen[800],
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ));
  }
}
