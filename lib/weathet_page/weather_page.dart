
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';

const String OPENWEATHER_API_KEY = "c8559f0278fc4f5fba4830795d3c044e";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  int _selectedIndex = 1;
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _cityName = "Sahiwal";  // Set a default city name
  final TextEditingController _cityController = TextEditingController();

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/images/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/images/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/images/rain.json';
      case 'thunderstorm':
        return 'assets/images/thunder.json';
      case 'clear':
        return 'assets/images/sunny.json';
      default:
        return 'assets/images/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_cityName);
  }

  void _fetchWeather(String cityName) {
    if (cityName.isEmpty) {
      print("City name is empty, cannot fetch weather.");
      return;
    }
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
        _cityName = 'Lohore'; // Update _cityName after fetching weather
      });
    }).catchError((e) {
      print("Error fetching weather: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: _buildUI(),
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

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Check Weather Condition',style:
              GoogleFonts.akshar(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500
              )
              ),
              Text('Where you want go!!!',style:
              GoogleFonts.aboreto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 100),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(4), left: Radius.circular(4)),
              ),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Search a City',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black87),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _cityName = _cityController.text; // Update _cityName
                        _fetchWeather(_cityName); // Fetch weather for new city
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _weather == null
                ? Center(child: CircularProgressIndicator())
                : _weatherDetails(),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetails() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          _dateTimeInfo(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          _weatherIcon(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          _currentTemp(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
        _weather?.areaName ?? "",
        style: GoogleFonts.akshar(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w500
        )
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: GoogleFonts.aboreto(
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.w900
          ),
        ),
        SizedBox(width: 10),
        Text(
          DateFormat("EEEE").format(now),
          style: GoogleFonts.akshar(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500
          ),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Lottie.asset(getWeatherAnimation(_weather?.weatherMain)),
        ),
        Text(
          "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
          style: GoogleFonts.aboreto(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      _weather?.weatherDescription ?? "",
      style: GoogleFonts.akshar(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w400
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: GoogleFonts.akshar(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: GoogleFonts.akshar(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: GoogleFonts.akshar(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: GoogleFonts.akshar(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:weather/weather.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// const String OPENWEATHER_API_KEY = "c8559f0278fc4f5fba4830795d3c044e";
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});
//
//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//
//   int _selectedIndex = 1;
//
//   void _onItemTapped(int index) {
//     print("Tapped on index: $index");
//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, "/search");
//         break;
//       case 1:
//         Navigator.pushNamed(context, "/weather");
//         break;
//       case 2:
//         Navigator.pushNamed(context, "/bookfil");
//         break;
//       default:
//         print("Invalid index: $index");
//     }
//   }
//
//   final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
//   Weather? _weather;
//   String _cityName = "Sahiwal";  // Set a default city name
//   final TextEditingController _cityController = TextEditingController();
//
//   String getWeatherAnimation(String? mainCondition) {
//     if (mainCondition == null) return "assets/images/sunny.json";
//
//     switch (mainCondition.toLowerCase()) {
//       case 'clouds':
//       case 'mist':
//       case 'smoke':
//       case 'haze':
//       case 'dust':
//       case 'fog':
//         return 'assets/images/cloud.json';
//       case 'rain':
//       case 'drizzle':
//       case 'shower rain':
//         return 'assets/images/rain.json';
//       case 'thunderstorm':
//         return 'assets/images/thunder.json';
//       case 'clear':
//         return 'assets/images/sunny.json';
//       default:
//         return 'assets/images/sunny.json';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather(_cityName);
//   }
//
//   void _fetchWeather(String cityName) {
//     if (cityName.isEmpty) {
//       print("City name is empty, cannot fetch weather.");
//       return;
//     }
//     _wf.currentWeatherByCityName(cityName).then((w) {
//       setState(() {
//         _weather = w;
//       });
//     }).catchError((e) {
//       print("Error fetching weather: $e");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       body: _buildUI(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 15, color: Colors.blue),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cloud, size: 15, color: Colors.blue),
//             label: 'Weather',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_work, size: 15, color: Colors.blue),
//             label: 'Search',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           _onItemTapped(index);
//         },
//       ),
//     );
//   }
//
//   Widget _buildUI() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Check Weather Condition',style:
//               GoogleFonts.akshar(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500
//               )
//               ),
//               Text('Where you want go!!!',style:
//               GoogleFonts.aboreto(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold
//               )
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 100),
//               ),
//               child: TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: 'Search a City',
//                   border: OutlineInputBorder(),
//                   labelStyle: TextStyle(color: Colors.black87),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       setState(() {
//                         _cityName = _cityController.text;
//                         _fetchWeather(_cityName);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _weather == null
//                 ? Center(child: CircularProgressIndicator())
//                 : _weatherDetails(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _weatherDetails() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _locationHeader(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           _dateTimeInfo(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           _weatherIcon(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           _currentTemp(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           _extraInfo(),
//         ],
//       ),
//     );
//   }
//
//   Widget _locationHeader() {
//     return Text(
//         _weather?.areaName ?? "",
//         style: GoogleFonts.akshar(
//             color: Colors.black,
//             fontSize: 30,
//             fontWeight: FontWeight.w500
//         )
//     );
//   }
//
//   Widget _dateTimeInfo() {
//     DateTime now = _weather!.date!;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           DateFormat("h:mm a").format(now),
//           style: GoogleFonts.aboreto(
//               color: Colors.black,
//               fontSize: 27,
//               fontWeight: FontWeight.w900
//           ),
//         ),
//         SizedBox(width: 10),
//         Text(
//           DateFormat("EEEE").format(now),
//           style: GoogleFonts.akshar(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w500
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherIcon() {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.20,
//           child: Lottie.asset(getWeatherAnimation(_weather?.weatherMain)),
//         ),
//         Text(
//           "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
//           style: GoogleFonts.aboreto(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w900
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _currentTemp() {
//     return Text(
//       _weather?.weatherDescription ?? "",
//       style: GoogleFonts.akshar(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.w400
//       ),
//     );
//   }
//
//   Widget _extraInfo() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.15,
//       width: MediaQuery.of(context).size.width * 0.80,
//       decoration: BoxDecoration(
//         color: Colors.lightBlue,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//               Text(
//                 "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//               Text(
//                 "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:weather/weather.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// const String OPENWEATHER_API_KEY = "c8559f0278fc4f5fba4830795d3c044e";
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});
//
//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//
//   int _selectedIndex = 1;
//
//   void _onItemTapped(int index) {
//     print("Tapped on index: $index");
//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, "/search");
//         break;
//       case 1:
//         Navigator.pushNamed(context, "/weather");
//         break;
//       case 2:
//         Navigator.pushNamed(context, "/bookfil");
//         break;
//       default:
//         print("Invalid index: $index");
//     }
//   }
//
//   final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
//   Weather? _weather;
//   String _cityName = "Sahiwal";
//   final TextEditingController _cityController = TextEditingController();
//
//   String getWeatherAnimation(String? mainCondition) {
//     if (mainCondition == null) return "assets/images/sunny.json";
//
//     switch (mainCondition.toLowerCase()) {
//       case 'clouds':
//       case 'mist':
//       case 'smoke':
//       case 'haze':
//       case 'dust':
//       case 'fog':
//         return 'assets/images/cloud.json';
//       case 'rain':
//       case 'drizzle':
//       case 'shower rain':
//         return 'assets/images/rain.json';
//       case 'thunderstorm':
//         return 'assets/images/thunder.json';
//       case 'clear':
//         return 'assets/images/sunny.json';
//       default:
//         return 'assets/images/sunny.json';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather(_cityName);
//   }
//
//   void _fetchWeather(String cityName) {
//     _wf.currentWeatherByCityName(cityName).then((w) {
//       setState(() {
//         _weather = w;
//       });
//     }).catchError((e) {
//       print("Error fetching weather: $e");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       body: _buildUI(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 15, color: Colors.blue),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cloud, size: 15, color: Colors.blue),
//             label: 'Weather',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_work, size: 15, color: Colors.blue),
//             label: 'Search',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           _onItemTapped(index);
//         },
//       ),
//     );
//   }
//
//   Widget _buildUI() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Check Weather Condition',style:
//                   GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w500
//                   )
//                   // GoogleFonts.abhayaLibre(
//                   //   color: Colors.black,
//                   //   fontSize: 24,
//                   //   fontWeight: FontWeight.bold
//                   // )
//
//                 ),
//               Text('Where you want go!!!',style:
//                   GoogleFonts.aboreto(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold
//                   )
//               // TextStyle(
//               //     color: Colors.black,
//               //     fontSize: 20,
//               //     fontWeight: FontWeight.w500,
//               // ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 100),
//               ),
//               child: TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: 'Search a City',
//                   border: OutlineInputBorder(),
//                   // labelText: 'Enter city name',
//                   labelStyle: TextStyle(color: Colors.black87),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       setState(() {
//                         _cityName = _cityController.text;
//                         _fetchWeather(_cityName);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _weather == null
//                 ? Center(child: CircularProgressIndicator())
//                 : _weatherDetails(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _weatherDetails() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _locationHeader(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           _dateTimeInfo(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           _weatherIcon(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           _currentTemp(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           _extraInfo(),
//         ],
//       ),
//     );
//   }
//
//   Widget _locationHeader() {
//     return Text(
//       _weather?.areaName ?? "",
//       style: GoogleFonts.akshar(
//           color: Colors.black,
//           fontSize: 30,
//           fontWeight: FontWeight.w500
//       )
//     );
//   }
//
//   Widget _dateTimeInfo() {
//     DateTime now = _weather!.date!;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           DateFormat("h:mm a").format(now),
//           style: GoogleFonts.aboreto(
//               color: Colors.black,
//               fontSize: 27,
//               fontWeight: FontWeight.w900
//           ),
//         ),
//         SizedBox(width: 10),
//         Text(
//           DateFormat("EEEE").format(now),
//           style: GoogleFonts.akshar(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w500
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherIcon() {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.20,
//           child: Lottie.asset(getWeatherAnimation(_weather?.weatherMain)),
//         ),
//
//     Text(
//     "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
//     style: GoogleFonts.aboreto(
//         color: Colors.black,
//         fontSize: 20,
//         fontWeight: FontWeight.w900
//     ),
//     ),
//
//       ],
//     );
//   }
//
//   Widget _currentTemp() {
//     return Text(
//       _weather?.weatherDescription ?? "",
//       style: GoogleFonts.akshar(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.w400
//       ),
//     );
//   }
//
//   Widget _extraInfo() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.15,
//       width: MediaQuery.of(context).size.width * 0.80,
//       decoration: BoxDecoration(
//         color: Colors.lightBlue,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//               Text(
//                 "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//               Text(
//                 "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
//                 style: GoogleFonts.akshar(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:weather/weather.dart';
//
// const String OPENWEATHER_API_KEY = "c8559f0278fc4f5fba4830795d3c044e";
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});
//
//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//   int _selectedIndex = 1;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       switch (_selectedIndex) {
//         case 0:
//           Navigator.pushNamed(context, "/searchFlight");
//           break;
//         case 1:
//           Navigator.pushNamed(context, "/weather");
//           break;
//         case 2:
//           Navigator.pushNamed(context, "/bookfil");
//           break;
//       }
//     });
//   }
//
//   final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
//   Weather? _weather;
//   String _cityName = "Lahore";
//   final TextEditingController _cityController = TextEditingController();
//
//   String getWeatherAnimation(String? mainCondition) {
//     if (mainCondition == null) return "assets/images/sunny.json";
//
//     switch (mainCondition.toLowerCase()) {
//       case 'clouds':
//       case 'mist':
//       case 'smoke':
//       case 'haze':
//       case 'dust':
//       case 'fog':
//         return 'assets/images/cloud.json';
//       case 'rain':
//       case 'drizzle':
//       case 'shower rain':
//         return 'assets/images/rain.json';
//       case 'thunderstorm':
//         return 'assets/images/thunder.json';
//       case 'clear':
//         return 'assets/images/sunny.json';
//       default:
//         return 'assets/images/sunny.json';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather(_cityName);
//   }
//
//   void _fetchWeather(String cityName) {
//     _wf.currentWeatherByCityName(cityName).then((w) {
//       setState(() {
//         _weather = w;
//       });
//     }).catchError((e) {
//       print("Error fetching weather: $e");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       body: _buildUI(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 15, color: Colors.blue),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cloud, size: 15, color: Colors.blue),
//             label: 'Weather',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_work, size: 15, color: Colors.blue),
//             label: 'Search',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//
//   Widget _buildUI() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 100),
//               ),
//               child: TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: 'Search a City',
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter city name',
//                   labelStyle: TextStyle(color: Colors.black87),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       setState(() {
//                         _cityName = _cityController.text;
//                         _fetchWeather(_cityName);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _weather == null
//                 ? Center(child: CircularProgressIndicator())
//                 : _weatherDetails(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _weatherDetails() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _locationHeader(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           _dateTimeInfo(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           _weatherIcon(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           _currentTemp(),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           _extraInfo(),
//         ],
//       ),
//     );
//   }
//
//   Widget _locationHeader() {
//     return Text(
//       _weather?.areaName ?? "",
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
//     );
//   }
//
//   Widget _dateTimeInfo() {
//     DateTime now = _weather!.date!;
//     return Column(
//       children: [
//         Text(
//           DateFormat("h:mm a").format(now),
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           DateFormat("EEEE").format(now),
//           style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherIcon() {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.20,
//           child: Lottie.asset(getWeatherAnimation(_weather?.weatherMain)),
//         ),
//         Text(
//           _weather?.weatherDescription ?? "",
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//       ],
//     );
//   }
//
//   Widget _currentTemp() {
//     return Text(
//       "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
//       style: TextStyle(color: Colors.black, fontSize: 20),
//     );
//   }
//
//   Widget _extraInfo() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.15,
//       width: MediaQuery.of(context).size.width * 0.80,
//       decoration: BoxDecoration(
//         color: Colors.lightBlue,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//               Text(
//                 "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//               Text(
//                 "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:weather/weather.dart';
//
// const String OPENWEATHER_API_KEY = "c8559f0278fc4f5fba4830795d3c044e";
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});
//
//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       switch (_selectedIndex) {
//         case 0:
//           Navigator.pushNamed(context, "/searchFlight");
//           break;
//         case 1:
//           Navigator.pushNamed(context, "/weather");
//           break;
//         case 2:
//           Navigator.pushNamed(context, "/bookfil");
//           break;
//       }
//     });
//   }
//
//
//
//   final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
//   Weather? _weather;
//   String _cityName = "Lahore";
//   final TextEditingController _cityController = TextEditingController();
//
//   String getWeatherAnimation(String? mainCondition) {
//     if(mainCondition == null) return "assets/images/sunny.json";
//
//     switch (mainCondition.toLowerCase()) {
//     case 'cloud';
//       case 'cloud';
//       case 'mist';
//       case 'smoke';
//       case 'haze';
//       case 'dust';
//       case 'fog';
//       return 'assets/images/cloud.json';
//       case 'rain';
//       case 'drizzle';
//       case 'shower rain';
//       return 'assets/images/rain.json';
//       case 'thunderStorm';
//       return 'assets/images/thunder.json';
//       case 'clear';
//       return 'assets/images/sunny.json';
//       default:
//         return 'assets/images/sunny.json';
//     }
//
//
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather(_cityName);
//   }
//
//   void _fetchWeather(String cityName) {
//     _wf.currentWeatherByCityName(cityName).then((w) {
//       setState(() {
//         _weather = w;
//       });
//     }).catchError((e) {
//       print("Error fetching weather: $e");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       // appBar: AppBar(
//       //   automaticallyImplyLeading: false,
//       //   title: Text('Weather App'),
//       // ),
//       body: _buildUI(),
//
//
//       bottomNavigationBar: SizedBox(
//         height: 50,
//         child: BottomNavigationBar(
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(context, "/searchFlight");
//                 },
//                 child: Icon(
//                   size: 15,
//                   Icons.home,
//                   color: Colors.blue,
//                 ),
//               ),
//               label: 'Home',
//               backgroundColor: Colors.white,
//             ),
//             BottomNavigationBarItem(
//               icon: InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(context, "/weather");
//                 },
//                 child: Icon(
//                   size: 15,
//                   Icons.cloud,
//                   color: Colors.blue,
//                 ),
//               ),
//               label: 'Weather',
//               backgroundColor: Colors.white,
//             ),
//             BottomNavigationBarItem(
//               icon: InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(context, "/bookfil");
//                 },
//                 child: Icon(
//                   size: 15,
//                   Icons.home_work,
//                   color: Colors.blue,
//                 ),
//               ),
//               label: 'Search',
//               backgroundColor: Colors.white,
//             ),
//           ],
//           type: BottomNavigationBarType.shifting,
//           currentIndex: _selectedIndex,
//           iconSize: 10,
//           onTap: _onItemTapped,
//           elevation: 2,
//         ),
//       ),
//
//
//
//     );
//   }
//
//   Widget _buildUI() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 100),
//               ),
//               child: TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: 'Search a City',
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter city name',
//                   labelStyle: TextStyle(color: Colors.black87),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       setState(() {
//                         _cityName = _cityController.text;
//                         _fetchWeather(_cityName);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _weather == null
//                 ? Center(child: CircularProgressIndicator())
//                 : _weatherDetails(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _weatherDetails() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _locationHeader(),
//           SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
//           _dateTimeInfo(),
//           SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
//           _weatherIcon(),
//           SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
//           _currentTemp(),
//           SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
//           _extraInfo(),
//         ],
//       ),
//     );
//   }
//
//   Widget _locationHeader() {
//     return Text(
//       _weather?.areaName ?? "",
//       style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
//     );
//   }
//
//   Widget _dateTimeInfo() {
//     DateTime now = _weather!.date!;
//     return Column(
//       children: [
//         Text(
//           DateFormat("h:mm a").format(now),
//           style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               DateFormat("EEEE").format(now),
//               style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
//             ),
//
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherIcon() {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           height: MediaQuery.sizeOf(context).height * 0.20,
//           // decoration: BoxDecoration(
//           //   image: DecorationImage(
//           //       image:
//           //       // AssetImage("assets/images/cloud.json"),
//           //       // NetworkImage(
//           //       //     "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")
//           //   ),
//           // ),
//           child: Lottie.asset(getWeatherAnimation(_weather.weatherMain)),
//         ),
//         Text(
//           _weather?.weatherDescription ?? "",
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//       ],
//     );
//   }
//
//   Widget _currentTemp() {
//     return Text(
//       "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
//       style: TextStyle(color: Colors.black, fontSize: 20),
//     );
//   }
//
//   Widget _extraInfo() {
//     return Container(
//       height: MediaQuery.sizeOf(context).height * 0.15,
//       width: MediaQuery.sizeOf(context).width * 0.80,
//       decoration: BoxDecoration(
//         color: Colors.lightBlue,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//               Text(
//                 "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//               Text(
//                 "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }