import 'package:flutter/material.dart';
import 'package:scany/constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "New PDF"),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "Open PDF"),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "Settings"),
        ],
        onTap: (index){
          if(index == 0)
          Navigator.of(context).pushNamed(newPdfScreen);
        },
      ),
    );
  }
}
