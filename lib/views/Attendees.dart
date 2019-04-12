import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendees extends StatefulWidget {
  final event;

  const Attendees(this.event);

  @override
  AttendeesState createState() => AttendeesState();
}

class AttendeesState extends State<Attendees> {
  var phoneNumber;
  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Enter the number of the person you want to invite"),
            content: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              // key: GlobalKey(debugLabel: 'phoneNumber'),
              onChanged: (value) => phoneNumber = value,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("add"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Firestore.instance
                      .collection('users')
                      .where('phone', isEqualTo: phoneNumber)
                      .getDocuments()
                      .then((documents) {
                    final person = documents.documents[0].data;
                    final attendeesList = List();
                    attendeesList.add(person['uid']);

                    attendeesList.addAll(widget.event['attendeesUids']);

                    Firestore.instance
                        .collection('events')
                        .document(widget.event['eventUid'])
                        .updateData({
                      'attendeesUids': attendeesList,
                      'attendeesNames.${person['uid']}': person['name']
                    });
                  });
                },
              ),
              new FlatButton(
                child: new Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('events')
            .where("eventUid", isEqualTo: widget.event['eventUid'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              final nameArr = [];
              snapshot.data.documents[0]['attendeesNames']
                  .forEach((key, value) {
                nameArr.add(value);
              });
              return Container(
                child: ListView(
                  children: nameArr.map((
                    name,
                  ) {
                    return new Card(
                      color: Colors.blue,
                      child: ListTile(
                        title: Center(
                          child: Text(
                            name,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
