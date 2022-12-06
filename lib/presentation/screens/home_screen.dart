import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scany/constants/strings.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bnbIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _bnbIndex,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.add),label: "New PDF"),
      //     BottomNavigationBarItem(icon: Icon(Icons.file_copy_sharp),label: "Open PDF"),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
      //   ],
      //   onTap: (index){
      //     setState(() {
      //       _bnbIndex = index;
      //     });
      //     if(index == 0)
      //     Navigator.of(context).pushNamed(newPdfScreen);
      //   },
      // ),
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, size.height),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.9,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(newPdfScreen);
                      },
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ),
                      elevation: 0.1,
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        "New PDF",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 6),
                    alignment: Alignment.bottomCenter,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.file_copy_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Files",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 25,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Recent",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

