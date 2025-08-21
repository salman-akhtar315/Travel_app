import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // This includes the controller
import 'package:google_fonts/google_fonts.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  // Use CarouselSliderController instead of CarouselController
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> imageList = [
      {
        "id": "1",
        "image_path": 'assets/images/traveling.jpg',
        "text1": "An Unforgettable holiday with Us",
        "text2": "If you are seeking adventure, dreaming of immersing yourself in culture and art, "
            "or relaxing in turquoise waters, Qatar has something for everyone."
      },
      {
        "id": "2",
        "image_path": 'assets/images/trip.png',
        "text1": "Why book online with us?",
        "text2": "If you are seeking adventure, dreaming of immersing yourself in culture and art, or relaxing in turquoise waters."
      },
      {
        "id": "3",
        "image_path": 'assets/images/weather.png',
        "text1": "Climate versus Weather",
        "text2": "Meteorologists use a computer-generated forecast as a guide. They combine it with additional data from current satellite and also rely on their own knowledge of weather processes"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 100),
          Expanded(
            child: Stack(
              children: [
                CarouselSlider(
                  items: imageList.map((item) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            item['image_path']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item['text1']!,
                            style: GoogleFonts.akshar(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item['text2']!,
                            style: GoogleFonts.akshar(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    aspectRatio: 1,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex == entry.key
                                ? Colors.red
                                : Colors.teal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xff4c505b),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Create a New Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

