import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/pages/login_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/search_flight_page.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:traveler/search_flight_page.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isSigningUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('    Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 33)),
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 17,),
                FormContainerWidget(
                  controller: _usernameController,
                  hintText: 'Username',
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: 'Email',
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPasswordField: true,
                ),

                Text("Enter six or above password!!", style: TextStyle(
                  // color: Color(0xff4c505b),
                  color: Colors.white
                ),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 30),
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xff4c505b),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isSigningUp
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xff4c505b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isSigningUp = true;
    });

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.signUpWithEmailAndPassword(context, email, password);

    setState(() {
      _isSigningUp = false;
    });

    if (user != null) {
      showToast(context, message: "User is successfully created");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchFlightPage(email: email),
        ),
      );
    } else {
      showToast(context, message: "Some error occurred");
    }
  }

  void showToast(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/login_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
//
// import '../../firebase_auth_implementation/firebase_auth_services.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   bool _isSigningUp = false;
//
//   final FirebaseAuthService _auth = FirebaseAuthService();
//
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text('    Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 33),),
//           backgroundColor: Colors.transparent, // Make AppBar transparent
//           elevation: 0,
//           // backgroundColor: Colors.blue,
//           // foregroundColor: Colors.white,
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Text(
//                 //   'Sign Up',
//                 //   style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//                 // ),
//                 // SizedBox(height: 0),
//                 FormContainerWidget(
//                   controller: _usernameController,
//                   hintText: 'Username',
//                   isPasswordField: false,
//                 ),
//                 SizedBox(height: 10),
//                 FormContainerWidget(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   isPasswordField: false,
//                 ),
//                 SizedBox(height: 10),
//                 FormContainerWidget(
//                   controller: _passwordController,
//                   hintText: 'Password',
//                   isPasswordField: true,
//                 ),
//                 SizedBox(height: 30),
//                 GestureDetector(
//                   onTap: _signUp,
//                   child: Container(
//                     width: double.infinity,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       color: Color(0xff4c505b),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: _isSigningUp
//                         ? Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     )
//                         : Center(
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Already have an account?",style: TextStyle(color: Colors.white),),
//                     SizedBox(width: 5),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => LoginPage()),
//                               (route) => false,
//                         );
//                       },
//                       child: Text(
//                         "Login",
//                         style: TextStyle(
//                             decoration: TextDecoration.underline,
//                           color: Color(0xff4c505b),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _signUp() async {
//     setState(() {
//       _isSigningUp = true;
//     });
//
//     String username = _usernameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     User? user = await _auth.signUpWithEmailAndPassword(context, email, password);
//
//     setState(() {
//       _isSigningUp = false;
//     });
//
//     if (user != null) {
//       showToast(context, message: "User is successfully created");
//       Navigator.pushNamed(context, "/search");
//     } else {
//       showToast(context, message: "Some error occurred");
//     }
//   }
//
//   void showToast(BuildContext context, {required String message}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
// }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/login_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
// import 'package:traveler/login-siginup/global/common/toast.dart';
//
// import '../../firebase_auth_implementation/firebase_auth_services.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   bool _isSigningUp = false;
//
//   final FirebaseAuthService _auth = FirebaseAuthService();
//
//   TextEditingController _usernameController = TextEditingController();
// TextEditingController _emailController = TextEditingController();
// TextEditingController _passwordController = TextEditingController();
//
// @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('SignUp',style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
//               SizedBox(height: 30),
//
//               FormContainerWidget(
//                 controller: _usernameController,
//                 hintText: 'Username',
//                 isPasswordField: false,
//               ),
//
//               SizedBox(height: 10),
//
//               FormContainerWidget(
//                 controller: _emailController,
//                 hintText: 'Email',
//                 isPasswordField: false,
//               ),
//
//               SizedBox(height: 10),
//
//               FormContainerWidget(
//                 controller: _passwordController,
//                   hintText: 'Password',
//                   isPasswordField: true
//               ),
//
//               SizedBox(height: 30),
//
//               GestureDetector(
//                 onTap: (){
//                   _signUp();
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 45,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child:_isSigningUp? Center(child: CircularProgressIndicator(color: Colors.white,)) : Center(
//                       child: Text('Sign Up', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Already have an account"),
//                   SizedBox(width: 5,),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);
//                     }, child: Text("Login",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void  _signUp() async{
//
//   setState(() {
//      _isSigningUp = true;
//   });
//
//     String username = _usernameController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;
//
//     User? user = await _auth.signUpWithEmailAndPassword(email, password);
//
//     setState(() {
//       _isSigningUp = false;
//     });
//
//
//     if (user != null) {
//       showToast(message: "User is successfully created");
//       Navigator.pushNamed(context, "/login");
//     } else {
//       showToast(message: "Some error happend");
//     }
//   }
//
//   void showToast({required String message}) {}
//
// }
