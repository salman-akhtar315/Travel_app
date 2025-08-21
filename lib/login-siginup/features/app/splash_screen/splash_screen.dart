import 'package:flutter/material.dart';
import 'package:traveler/image_slider.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
   Future.delayed(
       Duration(seconds: 3), () {
         // Navigator.pushAndRemoveUntil(context,
         //     MaterialPageRoute(builder: (context) => widget.child!),
         //     (route) => false);
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (context) => ImageSlider(), // Replace with your SignUpPage widget
       ),
     );
     // Navigator.pushReplacement(context, );
   }
   );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      // backgroundColor: Colors.blue,
      // backgroundColor: Color.fromRGBO(64, 147, 206, 100),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 313,
                width: 304,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(100),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img1.jpg',
                    height: 205,
                    width: 220,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Let’s Enjoy A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'New World',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 30,
              ),

              // Text(
              //   'Search the safest destination',
              //   style: TextStyle(
              //     color: Color(0xff4c505b),
              //     fontSize: 15,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(
              //   height: 60,
              // ),

              // Container(
              //   height: 50,
              //   width: 260,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color.fromRGBO(64, 147, 206, 100),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20.0)),
              //     ),
              //     onPressed: () {},
              //     child: Text(
              //       'Get Started',
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),


      // body: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/images/start.png'),
      //       fit: BoxFit.cover
      //     ),
      //   ),
      // ),
    );
  }
}
