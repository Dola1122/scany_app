import 'package:flutter/material.dart';
import 'package:scany/constants/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bnbIndex = 0;

  @override
  Widget build(BuildContext context) {
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

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 30);
    path.quadraticBezierTo(0, 20, 30, 20);
    path.lineTo(size.width * 0.35, 20);
    path.quadraticBezierTo(size.width * 0.40, 20, size.width * 0.42, 40);
    path.arcToPoint(Offset(size.width * 0.58, 40),
        radius: Radius.circular(33), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 20, size.width * 0.65, 20);
    path.lineTo(size.width - 30, 20);
    path.quadraticBezierTo(size.width, 20, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
