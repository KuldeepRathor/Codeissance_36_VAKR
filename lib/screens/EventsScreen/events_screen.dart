import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_event.dart';
import 'details.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            automaticallyImplyLeading: false,
            title: Text(
              "Events 🎊",
              style: TextStyle(fontSize: 26),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple,
            child: Icon(
              Icons.add,
              color: CupertinoColors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateEvent(),
                  ));
            },
          ),
          body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection("Events")
                .where("venue", isEqualTo: "")
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                    "Something went wrong ${snapshot.error.toString()}");
              }

              if (snapshot.hasData && snapshot.data!.docs.length == 0) {
                print("There was no document");
                return Container();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data();
                    return EventCard(
                      data: data,
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    color: Colors.grey,
                  ),
                );
              }
            },
          )),
    );
  }
}

class EventCard extends StatefulWidget {
  const EventCard({
    Key? key,
    required this.data,
  }) : super(key: key);
  final data;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 1.5),
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          // color: Colors.blue.shade50,
          // color: Colors.black,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("Community")
                  .where("uid", isEqualTo: widget.data["uid"])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return contentCard(
                      context, snapshot.data!.docs.first.data(), widget.data);
                } else {
                  return Container();
                }
              }),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Column contentCard(BuildContext context, snapshot, eventdata) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Eventdetails(
                    eventDetails: widget.data,
                    communityDetails: snapshot,
                  ),
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: Image.network(
                          // friendsSnapShot.data!['dp'],
                          snapshot["dp"])
                      // "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg")
                      .image,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snapshot["username"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                      ),
                    ),
                    Text(
                      // "alksdfhjdfadkfhjasldkfhjalksdfhjlaskdfj alsdkfhd klfjhasdfkjasdkflakdsfja dflakjdfhsalksdjfhlkasdjlakjfhklasdf asldkfhasdlkfhjaksdfhjakldfh asdlkfjasdlkfjasdfk ",
                      snapshot["bio"],
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              eventdata["image"],
                              // "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    final ref = FirebaseFirestore.instance
                                        .collection("Events")
                                        .doc(widget.data["eventId"]);

                                    if (widget.data["likes"].contains(
                                        FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                      await ref.update({
                                        "likes": FieldValue.arrayRemove([
                                          FirebaseAuth.instance.currentUser!.uid
                                        ])
                                      });
                                    } else {
                                      await ref.update({
                                        "likes": FieldValue.arrayUnion([
                                          FirebaseAuth.instance.currentUser!.uid
                                        ])
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: widget.data["likes"].contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Colors.red
                                        : Colors.grey,
                                  )),
                              Text("${eventdata["likes"].length}")
                            ],
                          ),
                          Text("${eventdata["joined"].length}k Joined.!")
                        ],
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
