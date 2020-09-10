import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String myText;

  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      FirebaseFirestore.instance.doc("myData/dummy");

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "KO KO",
      "desc": "Flutter Developer"
    };
    documentReference.set(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "KO KO Updated",
      "desc": "Flutter Developer Updated"
    };
    documentReference.update(data).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data().toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data().toString();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("CRUD"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _add,
              child: new Text("Add"),
              color: Colors.cyan,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _update,
              child: new Text("Update"),
              color: Colors.lightBlue,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _delete,
              child: new Text("Delete"),
              color: Colors.orange,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _fetch,
              child: new Text("Fetch"),
              color: Colors.lime,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            myText == null
                ? new Container()
                : new Text(
                    myText,
                    style: new TextStyle(fontSize: 20.0),
                  )
          ],
        ),
      ),
    );
  }
}
