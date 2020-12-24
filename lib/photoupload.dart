import 'package:blog_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'auth.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  // ignore: unused_field
  double _progress;
  final picker = ImagePicker();
  String _myValue, _myValues;
  String url;
  final formKey = new GlobalKey<FormState>();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //var tempImage = await ImagePicker(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        sampleImage = File(pickedFile.path);
      } else {
        print("no image");
      }
      //sampleImage = tempImage;
    });
  }

  validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      //double _progress;
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      // ignore: non_constant_identifier_names
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      uploadTask.events.listen((event) {
        setState(() {
          _progress = event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble();
        });
      });
      /*Text('Uploading ${(_progress * 100).toStringAsFixed(2)} %');
      LinearProgressIndicator(
        value: _progress,
      );*/
      goToHomePage();
      print("IMG URL" + url);
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "desc": _myValues,
      "date": date,
      "time": time,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new HomePage();
    }));
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      //body: Stack(
      //children: [
      //ClipPath(
      //clipper: OvalBottomBorderClipper(),

      //)
      //],
      //),
      /*body: Stack(children: [
        SizedBox(
          height: 40.0,
        ),*/
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new ClipOval(
              child: Material(
                color: Colors.pinkAccent,

                child: InkWell(
                  child: SizedBox(
                    //new Text("Logout"),
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.perm_identity,
                      size: 100,
                    ),
                  ),
                  //child: Text(),
                  //new Text
                  onTap: () async {
                    await _auth.signOut();
                  },
                ),
                //new Text(data)
              ),
            ),
            new Center(
              //ClipOval(),
              //TextAlign
              child: sampleImage == null
                  ? Text(
                      "SignOut",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: 30.0,
                        color: Colors.pink[200],
                      ),
                    )
                  : enableUpload(),
            ),
          ],
        )
            /*child: Center(
            //ClipOval(),
            //TextAlign
            child: sampleImage == null
                ? Text(
                    "Select an Image",
                    textAlign: TextAlign.center,
                  )
                : enableUpload(),
          ),*/
            //)
            //]
            /*Container(
         child: Center(
           //ClipOval(),
          //TextAlign
          child: sampleImage == null
              ? Text(
                  "Select an Image",
                  textAlign: TextAlign.center,
                )
              : enableUpload(),
        ),
      ),*/
            ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: new Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              (_progress != 0)
                  ? LinearProgressIndicator(
                      value: _progress,
                    )
                  : Container(),
              Image.file(
                sampleImage,
                height: 330.0,
                width: 660.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: new InputDecoration(labelText: 'English Text'),
                validator: (value) {
                  return value.isEmpty ? 'Description is required' : null;
                },
                onSaved: (value) {
                  return _myValue = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: new InputDecoration(labelText: 'Local Language'),
                validator: (value) {
                  return value.isEmpty ? 'Field is required' : null;
                },
                onSaved: (value) {
                  return _myValues = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                child: Text("Add a new Post"),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: uploadStatusImage,
              )
            ],
          ),
        ),
      ),
    );
  }
}
