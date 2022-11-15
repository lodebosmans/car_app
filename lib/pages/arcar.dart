import 'package:flutter/material.dart';
import '../widgets/armultipletargets.dart';
import '../widgets/arworld.dart';

class ArCarPage extends StatefulWidget {
  const ArCarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArCarPageState();
}

class _ArCarPageState extends State<ArCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cars"),
      ),
      body: const Center(
        // Here we load the Widget with the AR Dino experience
        child: ARWorldWidget(),
      ),
    );
  }
}
