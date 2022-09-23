import 'package:flutter/material.dart';
class Eventdetails extends StatelessWidget {
  const Eventdetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.share)),
                ],
              ),
              Text('Event name',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 30
              ),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    "https://image.shutterstock.com/shutterstock/photos/1041117601/display_1500/stock-vector-connect-logo-design-template-s-connect-icon-design-modern-network-logo-design-1041117601.jpg",
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(),
                  Text(' Communty Name'),
                ],
              ),

              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,\n sunt in culpa qui officia deserunt mollit anim id est laborum.'),
              ListTile(
                title: Text('event location'),
                subtitle: Text('date'),

              ),
              Center(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xff4700A2),
                      fixedSize: const Size(400, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),),

                      onPressed: (){}, child: Text('Join Event'))),



            ],
          ),
        ),
      ),));
  }
}
