import 'package:commect/screens/ChatScreen/sending_text_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "Chats",
              style: TextStyle(fontSize: 26),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                // reverse: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SendingTextScreen()));

                      print("tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              backgroundImage: Image.network(
                                      // friendsSnapShot.data!['dp'],
                                      "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg")
                                  .image,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // friendsSnapShot.data!['username'],
                                  "Username",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Message",
                                  // val == null
                                  //     ? chat["type"] == "message"
                                  //         ? chat["message"]
                                  //         : chat["type"] == "revertLike"
                                  //             ? "Reverted you 💞"
                                  //             : "Sent a pic"
                                  //     : friendsSnapShot.data!['role'],
                                  style: TextStyle(
                                      // color: Theme.of(context).cardColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                  // final friendKey = snapshot
                  //     .data!.snapshot.children
                  //     .elementAt(chatsLength - index - 1)
                  //     .key;
                  // return FriendListTile(friendKey,
                  //     chat: snapshot.data!.snapshot.children
                  //         .elementAt(chatsLength - index - 1)
                  //         .value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
