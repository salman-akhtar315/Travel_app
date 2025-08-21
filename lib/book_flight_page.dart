
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traveler/date_picker_widget.dart';

class BookFlightPage extends StatefulWidget {
  final String email;

  BookFlightPage({required this.email, Key? key}) : super(key: key);

  @override
  State<BookFlightPage> createState() => _BookFlightPageState();
}

class _BookFlightPageState extends State<BookFlightPage> {
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();
  int _selectedIndex = 1;
  bool showRoundTripFields = false;
  bool showOneWayFields = true;

  void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });
    print("Tapped on index: $index");
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/search");
        break;
      case 1:
        Navigator.pushNamed(context, "/weather");
        break;
      case 2:
        Navigator.pushNamed(context, "/bookfil");
        break;
      default:
        print("Invalid index: $index");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(300),
                    bottomRight: Radius.circular(300),
                  ),
                ),
                child: Center(
                  child: Image.asset('assets/images/img6.png'),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Book your flight',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(64, 147, 206, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showOneWayFields = true;
                          showRoundTripFields = false;
                        });
                      },
                      child: Text(
                        'One way',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(215, 234, 248, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showOneWayFields = false;
                          showRoundTripFields = true;
                        });
                      },
                      child: Text(
                        'Round Trip',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),


              showOneWayFields
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 308,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: TextStyle(fontSize: 17)),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(224, 237, 246, 100),
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('To', style: TextStyle(fontSize: 17)),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(224, 237, 246, 100),
                            filled: true,
                          ),
                        ),
                      ),
                      Text('Date', style: TextStyle(fontSize: 17)),
                      SizedBox(
                        height: 45,
                        child: MyDatePickerWidget(
                          dateController: dateController1,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff4c505b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'View Flights',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(),

              // Display round trip fields if showRoundTripFields is true
              showRoundTripFields
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 308,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: TextStyle(fontSize: 17)),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(224, 237, 246, 100),
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('To', style: TextStyle(fontSize: 17)),
                      SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(224, 237, 246, 100),
                            filled: true,
                          ),
                        ),
                      ),
                      Text('Date', style: TextStyle(fontSize: 17)),
                      SizedBox(
                        height: 45,
                        child: MyDatePickerWidget(
                          dateController: dateController2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(30, 170, 200, 200),
                            // backgroundColor: Color(0xff4c505b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'View Flights',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(), // Placeholder for the search flight form
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 15, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, size: 15, color: Colors.blue),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work, size: 15, color: Colors.blue),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}

