import 'package:flutter/material.dart';

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
          title: Text(
            "Events 🎊",
            style: TextStyle(fontSize: 26),
          ),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) {
            return EventCard();
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 1.5),
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          // color: Colors.blue.shade50,
          // color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      backgroundImage: Image.network(
                              // friendsSnapShot.data!['dp'],
                              "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg")
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
                          "Community Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.3,
                          ),
                        ),
                        Text(
                          "alksdfhjdfadkfhjasldkfhjalksdfhjlaskdfj alsdkfhd klfjhasdfkjasdkflakdsfja dflakjdfhsalksdjfhlkasdjlakjfhklasdf asldkfhasdlkfhjaksdfhjakldfh asdlkfjasdlkfjasdfk ",
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
                                  "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
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
                                children: [Icon(Icons.favorite), Text("123k")],
                              ),
                              Text("1234k Joined.!")
                            ],
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }
}
