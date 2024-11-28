 import 'package:flutter/material.dart';
import 'package:flutter_blue_serial_example/home_page.dart';


void main() => runApp(const Root());

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}
