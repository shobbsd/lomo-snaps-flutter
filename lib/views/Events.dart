import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import './EventPage.dart';

class EventsDashboard extends StatefulWidget {
  final user;

  const EventsDashboard(this.user);
  @override
  State<StatefulWidget> createState() {
    return EventsDashboardState();
  }
}

class EventsDashboardState extends State<EventsDashboard> {
  @override
  void didUpdateWidget(EventsDashboard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // final arr = Firestore.instance
    //     .collection('events')
    //     .where("attendeesUids", arrayContains: widget.user['uid'])
    //     .snapshots()
    //     .listen((data) =>
    //         data.documents.forEach((doc) => print(doc['eventName'])).toList());
  }

  // EventsDashboard(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Events!'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('events')
              .where("attendeesUids", arrayContains: widget.user['uid'])
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new Card(
                        color: Colors.deepPurpleAccent,
                        child: ListTile(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EventPage(document)),
                                )
                              },
                          title: Center(
                            child: Text(
                              document['eventName'],
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            children: <Widget>[
                              Text('dev date'),
                              Text('end date'),
                            ],
                          ),

                          // subtitle: new Text(document['author']),
                        ));
                  }).toList(),
                );
            }
          },
        ));
  }
}
