// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Tags extends StatefulWidget {
//   const Tags({Key? key}) : super(key: key);
//
//   @override
//   State<Tags> createState() => _TagsState();
// }
//
// class _TagsState extends State<Tags> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//
//         );
//       ],
//     );
//   }
// }
// class ListViewBuilder extends StatelessWidget {
//   const ListViewBuilder({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//           itemCount: 5,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//                 leading: const Icon(Icons.list),
//                 trailing: const Text(
//                   "GFG",
//                   style: TextStyle(color: Colors.green, fontSize: 15),
//                 ),
//                 title: Text("List item $index"));
//           }),
//     );
//   }
// }