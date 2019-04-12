import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './CameraTab.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import './Attendees.dart';
import './Images.dart';

class EventPage extends StatelessWidget {
  final DocumentSnapshot event;
  EventPage(this.event);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.folder_shared)),
            ],
          ),
          title: Text(event['eventName']),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Attendees(event),
            ImageGallery(event),
          ],
        ),
      ),
    );
  }
}
