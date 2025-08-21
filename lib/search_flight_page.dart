import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchFlightPage extends StatefulWidget {
  final String email;

  const SearchFlightPage({super.key, required this.email});

  @override
  State<SearchFlightPage> createState() => _SearchFlightPageState();
}

class _SearchFlightPageState extends State<SearchFlightPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              accountName: Text('Hi...'),
              accountEmail:  Text(
                '${widget.email}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login_outlined, color: Colors.lightBlue),
              title: Text('Logout'),
              onTap: () {

                Navigator.pushNamed(context, "/login");
              },

            ),

            ListTile(
              leading: Icon(Icons.cloud, color: Colors.lightBlue),
              title: Text('Weather'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/weather");
              },

            ),

          ],
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 35),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    SizedBox(width: 20),
                    // Text(
                    //   '${widget.email}',
                    //   style: TextStyle(color: Colors.white, fontSize: 20),
                    // ),
                    SizedBox(width: 40),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.white54)],
                        ),
                        child: Icon(
                          size: 35,
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Where you want to',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '   go?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search a flight',
                        // border: OutlineInputBorder(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Upcoming Trips',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 130,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(28, 94, 133, 100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '10 May, 01:30 pm',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '11 May, 08:15 am',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ABC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('.....'),
                          Icon(Icons.flight),
                          Text('.....'),
                          Text(
                            'XYZ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(173, 206, 225, 100),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Abianca, Filanto',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(40, 110, 150, 80),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            height: 20,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(173, 206, 225, 100),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Qatar, Ankara',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(40, 110, 150, 80),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Destinations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      popularDestinations('assets/images/img3.png', ' Paris', ' France'),
                      popularDestinations('assets/images/img4.png', ' Rome', ' Italy'),
                      popularDestinations('assets/images/img5.png', ' Istanbul', ' Turkey'),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget popularDestinations(String img, String city, String country) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 160,
      width: 95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            img,
            height: 114,
            width: 91,
          ),
          SizedBox(height: 2),
          Text(
            city,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            country,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 110, 150, 80),
            ),
          ),
        ],
      ),
    );
  }
}

