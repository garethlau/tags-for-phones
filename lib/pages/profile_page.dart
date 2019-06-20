import 'package:flutter/material.dart';
import 'package:tags/models/profile.dart';

class ProfilePage extends StatelessWidget {

  final Profile profile;

  ProfilePage({Key key, @required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(    
              title: Text(
                "${profile.firstName}" + " " + "${profile.lastName}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),  
              ),           
              background:
                  Hero(
                    tag: "${profile.email}",
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage("${profile.image}"),
                        )
                      ),
                    ),
                  ),

            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return (
                ListTile(
                  title: Center(
                    child: Text("${[index]}"),
                  ),
                )
              );
            },
            childCount: 20),
          )
        ],
      ),
    );
  }
}