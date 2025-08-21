import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:traveler/login-siginup/global/common/toast.dart';
import 'package:traveler/search_flight_page.dart'; // Assuming SearchFlightPage exists and takes email
import '../../firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Initialize GoogleSignIn as an instance variable
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'), // Ensure this asset is in pubspec.yaml and exists
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView( // Added SingleChildScrollView to prevent potential overflow with keyboard
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column( // Removed unnecessary Stack
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 65),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: 'Email',
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPasswordField: true,
                ),
                const Padding( // Added Padding for better spacing from the form field
                  padding: EdgeInsets.only(top: 4.0, left: 4.0), // Adjust as needed
                  child: Align( // Align text to the start
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter six or above password!!",
                      style: TextStyle(color: Color(0xff4c505b)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _isSigning ? null : _signIn, // Disable tap if already signing
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xff4c505b),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isSigning && !_isGoogleSigning // Differentiate between email and Google sign-in
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Center(
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _isSigning ? null : _signInWithGoogle, // Disable tap if already signing
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isGoogleSigning // Use a specific flag for Google sign-in
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.google, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        if (_isSigning) return; // Prevent navigation if signing in
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                              (route) => false,
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
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

  // To differentiate Google sign-in progress indicator
  bool _isGoogleSigning = false;

  void _signIn() async {
    if (_isSigning) return; // Prevent multiple sign-in attempts
    setState(() {
      _isSigning = true;
      _isGoogleSigning = false; // Ensure Google signing flag is off
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.signInWithEmailAndPassword(context, email, password);

    // Check if the widget is still mounted before calling setState
    if (!mounted) return;
    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      if (!mounted) return;
      Navigator.pushReplacement( // Use pushReplacement if you don't want to come back to login
        context,
        MaterialPageRoute(
          builder: (context) => SearchFlightPage(email: email),
        ),
      );
    } else {
      showToast(message: "Sign in failed. Please check your credentials.");
    }
  }

  void _signInWithGoogle() async {
    if (_isSigning) return; // Prevent multiple sign-in attempts
    setState(() {
      _isSigning = true;
      _isGoogleSigning = true; // Indicate Google sign-in is in progress
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        showToast(message: "Google sign-in was cancelled");
        if (!mounted) return;
        setState(() {
          _isSigning = false;
          _isGoogleSigning = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        showToast(message: "Failed to retrieve Google access token or ID token.");
        if (!mounted) return;
        setState(() {
          _isSigning = false;
          _isGoogleSigning = false;
        });
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;


      if (!mounted) return; // Check mount status before further operations
      setState(() {
        _isSigning = false;
        _isGoogleSigning = false;
      });

      if (user != null) {
        showToast(message: "Signed in with Google: ${user.displayName ?? user.email}");
        if (!mounted) return;
        Navigator.pushReplacement( // Use pushReplacement
          context,
          MaterialPageRoute(
            builder: (context) => SearchFlightPage(email: user.email ?? 'No email'), // Handle potential null email
          ),
        );
      } else {
        showToast(message: "Google Sign-In succeeded but no user data received.");
      }

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSigning = false;
        _isGoogleSigning = false;
      });
      showToast(message: "Google Sign-In error: $e");
      print("Google Sign-In detailed error: $e"); // Print for more debug info
    }
  }
}





// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
// import 'package:traveler/login-siginup/global/common/toast.dart';
// import 'package:traveler/search_flight_page.dart';
// import '../../firebase_auth_implementation/firebase_auth_services.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool _isSigning = false;
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/login.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Center(
//             child: Text(
//               'Login',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 33,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             child: Stack(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 65),
//                     FormContainerWidget(
//                       controller: _emailController,
//                       hintText: 'Email',
//                       isPasswordField: false,
//                     ),
//                     const SizedBox(height: 10),
//                     FormContainerWidget(
//                       controller: _passwordController,
//                       hintText: 'Password',
//                       isPasswordField: true,
//                     ),
//                     const Text(
//                       "Enter six or above password!!",
//                       style: TextStyle(color: Color(0xff4c505b)),
//                       textAlign: TextAlign.start,
//                     ),
//                     const SizedBox(height: 30),
//                     GestureDetector(
//                       onTap: _signIn,
//                       child: Container(
//                         width: double.infinity,
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: const Color(0xff4c505b),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: _isSigning
//                             ? const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Center(
//                           child: Text(
//                             'Sign In',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: _signInWithGoogle,
//                       child: Container(
//                         width: double.infinity,
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: Colors.lightBlueAccent,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               FaIcon(FontAwesomeIcons.google,
//                                   color: Colors.white),
//                               SizedBox(width: 10),
//                               Text(
//                                 "Sign in with Google",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don't have an account"),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const SignUpPage()),
//                                   (route) => false,
//                             );
//                           },
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               decoration: TextDecoration.underline,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
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
//   void _signIn() async {
//     setState(() {
//       _isSigning = true;
//     });
//
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     User? user =
//     await _auth.signInWithEmailAndPassword(context, email, password);
//
//     setState(() {
//       _isSigning = false;
//     });
//
//     if (user != null) {
//       showToast(message: "User is successfully signed in");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchFlightPage(email: email),
//         ),
//       );
//     } else {
//       showToast(message: "Some error occurred");
//     }
//   }
//
//   void _signInWithGoogle() async {
//     try {
//       final GoogleSignIn _googleSignIn = GoogleSignIn();
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         showToast(message: "Google sign-in was cancelled");
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       await FirebaseAuth.instance.signInWithCredential(credential);
//
//       showToast(message: "Signed in with Google");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchFlightPage(email: googleUser.email),
//         ),
//       );
//     } catch (e) {
//       showToast(message: "Google Sign-In error: $e");
//     }
//   }
// }







// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
// // import 'package:traveler/login-siginup/features/user_auth/presentation/pages/search_flight_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
// import 'package:traveler/login-siginup/global/common/toast.dart';
// import 'package:traveler/search_flight_page.dart';
//
// import '../../firebase_auth_implementation/firebase_auth_services.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool _isSigning = false;
//   final FirebaseAuthService _auth = FirebaseAuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Center(
//             child: Text(
//               'Login',
//               style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold),
//             ),
//           ),
//           backgroundColor: Colors.transparent, // Make AppBar transparent
//           elevation: 0,
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             child: Stack(children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 65),
//                   FormContainerWidget(
//                     controller: _emailController,
//                     hintText: 'Email',
//                     isPasswordField: false,
//                   ),
//                   SizedBox(height: 10),
//                   FormContainerWidget(
//                     controller: _passwordController,
//                     hintText: 'Password',
//                     isPasswordField: true,
//                   ),
//
//                   Text("Enter six or above password!!", style: TextStyle(
//                     color: Color(0xff4c505b),
//                   ),
//                      textAlign: TextAlign.start,
//                   ),
//
//                   SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: _signIn,
//                     child: Container(
//                       width: double.infinity,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Color(0xff4c505b),
//                         // color: Colors.lightBlueAccent,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: _isSigning
//                           ? InkWell(
//                         onTap: (){},
//                             child: Center(
//                               child: CircularProgressIndicator(
//                             color: Colors.white,
//                                                     ),
//                                                   ),
//                           )
//                           : Center(
//                         child: Text(
//                           'Sign In',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: _signInWithGoogle,
//                     child: Container(
//                       width: double.infinity,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Colors.lightBlueAccent,
//                         // color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             InkWell(onTap: (){}, child: IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.google))),
//                             SizedBox(width: 5),
//                             Text(
//                               "Sign in with Google",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don't have an account"),
//                       SizedBox(width: 5),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignUpPage()),
//                                 (route) => false,
//                           );
//                         },
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _signIn() async {
//     setState(() {
//       _isSigning = true;
//     });
//
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     User? user = await _auth.signInWithEmailAndPassword(context, email, password);
//
//     setState(() {
//       _isSigning = false;
//     });
//
//     if (user != null) {
//       showToast(context, message: "User is successfully signed in");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchFlightPage(email: email),
//         ),
//       );
//     } else {
//       showToast(context, message: "Some error occurred");
//     }
//   }
//
//   void showToast(BuildContext context, {required String message}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   _signInWithGoogle() async {
//     final auth = FirebaseAuth.instance;
//     final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           idToken: googleSignInAuthentication.idToken,
//           accessToken: googleSignInAuthentication.accessToken,
//         );
//
//         await _firebaseAuth.signInWithCredential(credential);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SearchFlightPage(email: googleSignInAccount.email),
//           ),
//         );
//       }
//     } catch (e) {
//       showToast(context, message: "some error occured $e");
//     }
//   }
// }
//
// class _firebaseAuth {
//   static signInWithCredential(AuthCredential credential) {}
// }








// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/home_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
// import 'package:traveler/login-siginup/global/common/toast.dart';
//
// import '../../firebase_auth_implementation/firebase_auth_services.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool _isSigning = false;
//   final FirebaseAuthService _auth = FirebaseAuthService();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//           backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Center(child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold),)),
//       backgroundColor: Colors.transparent, // Make AppBar transparent
//       elevation: 0,
//           // backgroundColor: Colors.blue,
//           // foregroundColor: Colors.white,
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Stack(
//               children: [
//                 Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//
//                   // Text(
//                   //   'Login',
//                   //   style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//                   // ),
//                   SizedBox(height: 50),
//                   FormContainerWidget(
//                     controller: _emailController,
//                     hintText: 'Email',
//                     isPasswordField: false,
//                   ),
//                   SizedBox(height: 10),
//                   FormContainerWidget(
//                     controller: _passwordController,
//                     hintText: 'Password',
//                     isPasswordField: true,
//                   ),
//                   SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: _signIn,
//                     child: Container(
//                       width: double.infinity,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Color(0xff4c505b),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: _isSigning
//                           ? Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       )
//                           : Center(
//                         child: Text(
//                           'Sign In',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 10),
//
//                   GestureDetector(
//                     onTap: ()  {
//                       _signInWithGoogle();
//
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(onPressed: () {},
//                                 icon: FaIcon(FontAwesomeIcons.google)),
//                             // Icon(FontAwesomeIcons.google, color: Colors.white,),
//                             // Icon(Icons.add_sharp, color:  Colors.white,),
//                             SizedBox(width: 5,),
//                             Text(
//                               "Sign in with Google",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don't have an account"),
//                       SizedBox(width: 5),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignUpPage()),
//                                 (route) => false,
//                           );
//                         },
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ]
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _signIn() async {
//     setState(() {
//       _isSigning = true;
//     });
//
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     User? user = await _auth.signInWithEmailAndPassword(context, email, password);
//
//     setState(() {
//       _isSigning = false;
//     });
//
//     if (user != null) {
//       showToast(context, message: "User is successfully signed in");
//       Navigator.pushNamed(context, "/search");
//     } else {
//       showToast(context, message: "Some error occurred");
//     }
//   }
//
//
//   void showToast(BuildContext context, {required String message}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   _signInWithGoogle() async{
//     final  auth = FirebaseAuth.instance;
//     final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//
//       if(googleSignInAccount != null ){
//         final GoogleSignInAuthentication googleSignInAuthentication = await
//         googleSignInAccount.authentication;
//
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           idToken: googleSignInAuthentication.idToken,
//           accessToken: googleSignInAuthentication.accessToken,
//         );
//
//         await _firebaseAuth.signInWithCredential(credential);
//         Navigator.pushNamed(context, "/home");
//       }
//     }catch(e) {
//       showToast(context,message: "some error occured $e");
//     }
//
//   }
//
//
//
// }
//
// class _firebaseAuth {
//   static signInWithCredential(AuthCredential credential) {}
// }




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/home_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/pages/sign_up_page.dart';
// import 'package:traveler/login-siginup/features/user_auth/presentation/widgets/form_container_widget.dart';
// import 'package:traveler/login-siginup/global/common/toast.dart';
//
// import '../../firebase_auth_implementation/firebase_auth_services.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//   bool _isSigning = false;
//
//   final FirebaseAuthService _auth = FirebaseAuthService();
//
//
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Login',style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
//             SizedBox(height: 30),
//               FormContainerWidget(
//                 controller: _emailController,
//                 hintText: 'Email',
//                 isPasswordField: false,
//               ),
//               SizedBox(height: 10),
//               FormContainerWidget(
//                 controller: _passwordController,
//                 hintText: 'Password',
//                 isPasswordField: true
//               ),
//               SizedBox(height: 30),
//               GestureDetector(
//                 onTap: (){
//                   _signIn();
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 45,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child:_isSigning
//                       ? Center(
//                         child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                           ),
//                       )
//                       : Center(
//                     child: Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Don't have an account"),
//                   SizedBox(width: 5,),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignUpPage()), (route) => false);
//                     }, child: Text("Sign Up",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
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
//   void  _signIn() async{
//
//
//     setState(() {
//       _isSigning = true;
//     });
//
//     String email = _emailController.text;
//     String password = _passwordController.text;
//
//     User? user = await _auth.signInWithEmailAndPassword(email, password);
//
//
//     setState(() {
//        _isSigning = false;
//     });
//
//     if (user != null) {
//       showToast(message: "User is successfully SignIn");
//       Navigator.pushNamed(context, "/home");
//     } else {
//       showToast(message: "Some error happend");
//     }
//   }
//
//   void showToast({required String message}) {}
//
// }
