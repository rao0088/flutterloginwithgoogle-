import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedIn= false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user){
      if(user==null){
        Navigator.pushReplacementNamed(context, "/LoginPage");
      }

    });
  }

  getUser() async{
    FirebaseUser firebaseUser =await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null){
      setState(() {
        this.user =firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async{
    _auth.signOut();
  }
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child:Center(
          child: !isSignedIn?CircularProgressIndicator()
              : Column(
            children: <Widget>[

              Text(
                "hello,${user.displayName} Email id:${user.email} phone no:${user.phoneNumber}"
              ),

              Container(child:Image.network(user.photoUrl,width: 300.0,height: 300,)),

              Container(
                padding: EdgeInsets.fromLTRB(100.0,20.0,100.0,20.0),
                child: RaisedButton(
                  onPressed: signOut,
                  child: Text(
                    'SingnOut'
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
