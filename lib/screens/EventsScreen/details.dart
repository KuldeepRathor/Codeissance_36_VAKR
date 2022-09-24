import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Eventdetails extends StatelessWidget {
  const Eventdetails(
      {Key? key, required this.eventDetails, required this.communityDetails})
      : super(key: key);
  final eventDetails;
  final communityDetails;

  String getDateTime(Timestamp t) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
    return "${date.day} / ${date.month} / ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                ],
              ),
              Text(
                eventDetails["eventName"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    eventDetails["image"],
                    // "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    backgroundImage: Image.network(
                            // friendsSnapShot.data!['dp'],
                            communityDetails["dp"])
                        // "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg")
                        .image,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(communityDetails["username"]),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(eventDetails["desc"]),
              // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,\n sunt in culpa qui officia deserunt mollit anim id est laborum.'),
              ListTile(
                title: Text(eventDetails["venue"]),
                subtitle: Text(getDateTime(eventDetails["date"])),
              ),
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4700A2),
                        fixedSize: const Size(400, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        joinEvent(eventDetails["eventId"]);
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              'Joined Event',
                              style: TextStyle(color: Colors.green),
                            ),
                            content: const Text('Event Joined Successfully'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Join Event'))),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> joinEvent(docIc) async {
    final ref = FirebaseFirestore.instance.collection("Events").doc(docIc);
    await ref.update({
      "joined": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }
}
