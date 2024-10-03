import 'package:drawer3d_animation/drawer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: Container(
          color: Colors.grey,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 80, top: 100),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item: $index'),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer'),
        ),
        body: Container(
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
