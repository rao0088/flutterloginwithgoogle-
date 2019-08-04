import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey <FormState> _formkey =GlobalKey<FormState>();
  String _email,_password;

  checkAuthentication()async{

    _auth.onAuthStateChanged.listen((user) async{
      if(user!=null){

        Navigator.pushReplacementNamed(context, "/");

      }
    });
  }

  navigateToSignupScreen(){
    Navigator.pushReplacementNamed(context, "/singup");
  }
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  void signin() async{

    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{

       //FirebaseUser user = await _auth.signInWithEmailAndPassword(email: _email, password: _password).user;
        FirebaseUser user = (await FirebaseAuth.instance.
        signInWithEmailAndPassword(email: _email, password: _password))
            .user;


      } catch(e){

        showError(e.message);

      }
    }

  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

   // print(user);
    try{
      if(user !=null){

        //return user;
        print("signed in " + user.displayName);
      }
    }catch(e){

      showError(e.message);

    }
    return user;

  }

  showError(String errorMessage){
    showDialog(
        context: context,
      builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.only(top:20.0),
                      child: TextFormField(
                        validator:(input){
                          if(input.isEmpty){
                            return'Email Feild Required';
                          }

                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        onSaved: (input)=>_email=input,
                      ),
                      ),

                      Container(
                        padding:EdgeInsets.only(top:20.0),
                        child: TextFormField(
                          validator:(input){
                            if(input.length<6){
                              return'password sould be Lenth 6 Digit';
                            }

                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input)=>_password=input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:20.0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0,20.0,100.0,20.0),
                          color: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          onPressed: signin,
                          child: Text('login',style: TextStyle(
                            color: Colors.white
                          ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30.0),
                        child: RaisedButton(
                          onPressed:(){
                            _handleSignIn()
                                .then((FirebaseUser user) => print(user))
                                .catchError((e) => print(e));
                          },
                          child: Text('Sign With Google'),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignupScreen,
                        child: Text('Create An Account',
                        textAlign: TextAlign.center,),

                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
