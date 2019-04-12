import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class ImageGallery extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Images'),
//         ),
//         body: GridView.count(
//           // Create a grid with 2 columns. If you change the scrollDirection to
//           // horizontal, this would produce 2 rows.
//           crossAxisCount: 2,
//           // Generate 100 Widgets that display their index in the List
//           children: List.generate(100, (index) {
//             return Center(
//               child: Text(
//                 'Item $index',
//                 style: Theme.of(context).textTheme.headline,
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

class ImageGallery extends StatelessWidget {
  final event;
  ImageGallery(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('events')
          .where("eventUid", isEqualTo: event['eventUid'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            final imageList = [];
            snapshot.data.documents[0]['images'].forEach((key) {
              imageList.add(key);
            });
            return GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this would produce 2 rows.
              crossAxisCount: 2,

              // Generate 100 Widgets that display their index in the List
              children: List.generate(imageList.length, (index) {
                return Center(child: Image.network(imageList[index]));
              }),
            );
        }
      },
    ));
  }
}
