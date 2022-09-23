import 'package:flutter/material.dart';
class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  @override
  Widget Communitycard(String name, String details, String followers) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(borderRadius:BorderRadius.circular(15),child: Image.network("https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg")),
              title: Text(name),
              subtitle:Text(details) ,
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('If you want to connect a book nerd just like yourself dont hesitate and join our community'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return Communitycard(
        'book club','tag line','20'
          );
    });
  }
}
