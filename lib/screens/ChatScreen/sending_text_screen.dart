import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SendingTextScreen extends StatefulWidget {
  const SendingTextScreen({super.key});

  @override
  State<SendingTextScreen> createState() => _SendingTextScreenState();
}

class _SendingTextScreenState extends State<SendingTextScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 60,
              color: Colors.black,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // widget.friend!["username"],
                        "Community Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage: Image.network(
                                "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg" // widget.friend!["dp"],
                                )
                            .image,
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: ListView.builder(
                // controller: _controller,
                itemCount: 20,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    // width: MediaQuery.of(context).size.width * 0.3,
                    // height: 100,
                    // constraints: BoxConstraints(
                    //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                    // ),
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        // alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                        alignment: index % 2 == 0
                            //  chat["sentBy"] == FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                            color:
                                // chat["sentBy"] == FirebaseAuth.instance.currentUser!.uid
                                index % 2 == 0
                                    ? Color(0xff4700a2)
                                    : Theme.of(context).cardColor,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Messagews TExts",
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                  );
                  // final chat = snapshot.data!.snapshot.children
                  //     .elementAt(index)
                  //     .value as Map?;
                  // if (chat!["type"] == "revertLike") {
                  //   return Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         chat["message"],
                  //         style: TextStyle(color: Colors.grey),
                  //       ),
                  //       Image.asset(
                  //         "assets/images/revertlikeback.png",
                  //         color: Colors.red,
                  //         height: 30,
                  //       )
                  //     ],
                  //   );
                  // }

                  // return MessagesWidget(
                  //   chat: chat,
                  // );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Row(
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     decoration: BoxDecoration(
                    //       color: Colors.lightBlue,
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     child: Icon(
                    //       Icons.add,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        // controller: messageTextController,
                        decoration: InputDecoration(
                            hintText: "Type a Message",
                            // hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // sendChatToRTDB();

                        // _controller.animateTo(
                        //   _controller.position.maxScrollExtent + 40,
                        //   duration: const Duration(milliseconds: 200),
                        //   curve: Curves.fastOutSlowIn,
                        // );
                        // messageTextController.text = '';
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color(0xff4700a2),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
