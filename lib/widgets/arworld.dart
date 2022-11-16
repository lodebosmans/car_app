import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:flutter/material.dart';
import '../models/objectReceived.dart';
import '../apis/car_api.dart';
import 'package:car_app/utils/user_secure_storage.dart';
import '../models/personalCar.dart';

class ARWorldWidget extends StatefulWidget {
  const ARWorldWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ARWorldWidgetState createState() => _ARWorldWidgetState();
}

class _ARWorldWidgetState extends State<ARWorldWidget>
    with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey =
      "1o9r1IvdiAVq1z5Itc+mTnxHKqHN4AJLFGFQMZIIk4KxVwyCDR98dtJ5uUjcrZs1bU5fZnZAT5sagoWz5S3L2boRuqihtgHqEv+3Qix3NK0BKJWJvMAamau231eeleBKHuaWBeLCrdxUKMSGHcr/K/O6xibZSw4Zhv/7SsWutwpTYWx0ZWRfXxLcVx9uTx497+NulVWSee290QPIHVpbDpkk6nPQCpC0N+l+EjdgJXv6fWQ2zDeF6SAmmO/YKP35y5s//QCDE4aHz9pRkXSCtP/3/7twxgg02zy1VMLG5RJDqCQThGCozQdJEcAVGTU/+HWBpK+QBa3NmDlJwljmYpW+jYn0ZJ9qgHD2oUWx0OJ8VolvwLucqwVjnGATpIHwS87koGTBCl3ZWn4CjZt7KIyXW+3DvwXF73zH7Cuvh6CubjnMzWHSNNmUQiLOhMgLfdjPyECsVzhKaJwf7ZoRziKm5BfneQNUy/Q6BeeizDMJx/q9msCHopGWcvsvFus9iVsLRTe7agXt6pRr4azx7Wcs2cCOYM1dqzMMYHd95JpTumRgo3imHQe312OTIUig7Wr6NrH/zNPkAC/hBx4Vo1G4k4UU52hyN1IiKxQaRLzPXSkAnhCzxMFwuiBnQUY0NdrAPHzm0UkKkY0jI78LABD+eV2UNbCrR2ESA441l9QcM2ufm/rck+yqH4A2gXts+TnhfWKreKFcWhXVVHJWmlRjsIpezDILwZEl12nAqCyU1hZVzCJhNF8MvARji8wK+DB0vL0f55FCZLKlMJ3vy2yU0fU0PZjzFhQc+cSDz7v2EiAzdgOqMwbPkoG+xOhaOqaYBgN8iSPEtkQQEjhUxQ==";
  StartupConfiguration startupConfiguration = StartupConfiguration(
      cameraPosition: CameraPosition.BACK,
      cameraResolution: CameraResolution.AUTO);
  List<String> features = ["object_tracking"];
  String userName = '';
  List<PersonalCar> carList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();

    // Get the username from the local storage
    Future init() async {
      final tempName = await UsersecureStorage.getUserName() ?? '';
      setState(() {
        userName = tempName.toLowerCase();
        _getPersonalCars();
      });
    }

    init();

    WidgetsBinding.instance.addObserver(this);

    architectWidget = ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: startupConfiguration,
      features: features,
    );
  }

  void _getPersonalCars() {
    CarApi.fetchPersonalCars(userName).then((result) {
      setState(() {
        carList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: architectWidget, //ar widget
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        architectWidget.pause();
        break;
      case AppLifecycleState.resumed:
        architectWidget.resume();
        break;

      default:
    }
  }

  @override
  void dispose() {
    architectWidget.pause();
    architectWidget.destroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onArchitectWidgetCreated() async {
    architectWidget.load(
        "wikitude_object_tracking/index.html", onLoadSuccess, onLoadFailed);
    architectWidget.resume();
    architectWidget.setJSONObjectReceivedCallback(
        (result) => onJSONObjectReceived(result, userName, carList));
  }

  void onJSONObjectReceived(
      Map<String, dynamic> jsonObject, userName, carList) async {
    var resultobject = ARImageResponse.fromJson(jsonObject);
    String carBrand = resultobject.objectScanned;

    bool carAlreadyScanned = false;
    for (int i = 0; i < carList.length; i++) {
      if (carList[i].carBrand.toString() == carBrand) {
        carAlreadyScanned = true;
      }
    }

    if (carAlreadyScanned == false) {
      CarApi.updateRating(userName, carBrand, 0);
    }

  }

  Future<void> onLoadSuccess() async {
    debugPrint("Successfully loaded Architect World");
  }

  Future<void> onLoadFailed(String error) async {
    debugPrint("Failed to load Architect World");
    debugPrint(error);
  }
}