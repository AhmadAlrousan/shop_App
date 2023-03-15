// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth-Screen";
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(215, 188, 117, 1).withOpacity(0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurpleAccent.shade700,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      "My shop",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Anton',
                      ),
                    ),
                  )),
                  Flexible(
                    child: _AuthCard(),
                    flex: deviceSize.width > 600 ? 2 : 1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AuthCard extends StatefulWidget {

  @override
  State<_AuthCard> createState() => _AuthCardState();
}

enum AuthMode { Login, SingUp }

class _AuthCardState extends State<_AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _FormKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'Password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
  }

  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<void> _submit() async {
    if (!_FormKey.currentState!.validate()) {
      return;
    }
    _FormKey.currentState!.save();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['Password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['Password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use .';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address .';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak .';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'could not find a user with that email . ';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = ' Invalid Password.';
      }
      _showErrorDilog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. please try again later';
      _showErrorDilog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDilog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occurred!"),
              content: Text(message),
              actions: [
                TextButton(
        child: Text("Ok"),
        onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                )
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SingUp;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SingUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SingUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _FormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(labelText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains("@")) {
                        return "invalid email";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['email'] = val!;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 5) {
                        return " Password is to short ";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _authData['Password'] = val!;
                    }),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SingUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SingUp ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SingUp,
                        decoration:
                            InputDecoration(labelText: "Confirm Password"),
                        obscureText: true,
                        validator: _authMode == AuthMode.SingUp
                            ? (val) {
                                if (val != _passwordController.text) {
                                  return " Password do not match!! ";
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading) CircularProgressIndicator(),
                ElevatedButton(
                  child: Text(
                    _authMode == AuthMode.Login ? "Login" : "Signup",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _submit,


                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      "${_authMode == AuthMode.Login ? "Signup" : "login"} INSTEAD"),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
