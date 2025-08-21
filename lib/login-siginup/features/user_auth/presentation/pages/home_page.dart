


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Scaffold(
//       appBar: AppBar(
//         title: Text('Home page'),
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: Text('Welcome to home'),
//           ),
//           SizedBox(height: 20,),
//           GestureDetector(
//             onTap: (){
//               FirebaseAuth.instance.signOut();
//               Navigator.pushNamed(context, "/login");
//             },
//             child: Container(
//               width: double.infinity,
//               height: 45,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(child: Text('Sign out', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
