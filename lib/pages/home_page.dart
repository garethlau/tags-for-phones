import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tags/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tags/models/profile.dart';
import 'package:tags/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  HomePage({Key key, this.auth,this.userId, this.onSignedOut}): super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScrollView(),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getMyProfile();
        },
      ),
    );
  }

  _getMyProfile() async {
    _signOut();
  }

  _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Awdwdw"),
            accountEmail: Text("email.gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.red,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ExpansionTile(
            title: Text("Region"),
            children: <Widget>[
              ListTile(
                title: Text("Tokyo"),
              ),
              ListTile(
                title: Text("San Fransisco"),
              ),
              ListTile(
                title: Text("Calgary"),
              ),
            ], 
          ),
          ListTile(
            title: Text("Item 1"),
          ),
          ListTile(
            title: Text("Item 2"),
          ),
        ],
      ),
    );
  }

  _buildScrollView() {
    return (
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Tags",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),
          ),
          FutureBuilder<List<Profile>>(
            future: _getProfiles(),
            builder: (context, snapshot) {
              print("length" + snapshot.toString());
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              if (snapshot.hasData && snapshot.data.length != 0) {
                if (snapshot.data != null) {
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300.0,
                      mainAxisSpacing: 10.0, // vertical seperation
                      crossAxisSpacing: 0.0,  // horizontal seperation
                      childAspectRatio: 0.75,  // ratio cross-axis to the main extent 
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      print("index is" + index.toString());
                      return (
                        Hero(
                          tag: "${snapshot.data[index].email}",
                          child: InkWell(
                            child: Card(
                              color: Colors.blue,
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                    "${snapshot.data[index].image}",
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data[index].firstName}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data[index].title}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ], 
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(profile: snapshot.data[index]),
                                ),
                              );
                            },
                          )
                        )
                      );
                    },
                    childCount: snapshot.data.length,
                    ),
                  );
                }
              } else {
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300.0,
                    mainAxisSpacing: 10.0, // vertical seperation
                    crossAxisSpacing: 0.0,  // horizontal seperation
                    childAspectRatio: 0.75,  // ratio cross-axis to the main extent 
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return (
                      Card(
                        color: Colors.blue,
                        child: Center(
                          child: Text("${[index]}"),
                        ),
                      )
                    );
                  },
                  childCount: 20),
                );
              }
              
            },
          ),
        ],
      )
    );
  }



  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch (err) {
      print(err);
    }
  }
}

Future<List<Profile>> _getProfiles() async {
  QuerySnapshot querySnapshot = await Firestore.instance.collection("test-for-dev").getDocuments();
  var profilesArray = new List<Profile>();
  querySnapshot.documents.forEach((documentSnapshot) {
    profilesArray.add(Profile.fromJson(documentSnapshot.data));
  });
  return profilesArray;
}




