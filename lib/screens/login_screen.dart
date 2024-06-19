import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remote_health/defaults/round_gradient_button.dart';
import 'package:remote_health/defaults/round_text_field.dart';
import 'package:remote_health/screens/signup_screen.dart';
import 'package:remote_health/utils/app_colors.dart';
import '../dashboard.dart';

class LoginScreen extends StatefulWidget {
  final String title;
  const LoginScreen({super.key, required this.title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();

  Future<User?> _signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login Successfully"))
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (context) => Dashboard()
      ));
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Login Failed, Please check your email and password")),
      );
      return null;
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);
  GoogleSignInAccount? _currentUser;


  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account!;
      });
      _handleFirebase();
    });

    _googleSignIn.signInSilently();
  }

  _handleFirebase() async {
    GoogleSignInAuthentication googleAuth = await _currentUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      print('Login');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Login Successfully"))
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.height * 0.1,
                    ),
                    SizedBox(
                      width: media.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: media.width * 0.03,
                          ),
                          Text(
                            "Hey There",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.03,
                          ),
                          Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                    RoundTextField(
                      textEditingController: _emailController,
                      hintText: "Email",
                      icon: "assets/Icons/message_icon.png",
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    RoundTextField(
                      textEditingController: _passController,
                      hintText: "Password",
                      icon: "assets/Icons/lock.png",
                      textInputType: TextInputType.text,
                      isObsecureText: isObscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        return null;
                      },
                      rightIcon: TextButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            isObscure
                                ? "assets/Icons/show.png"
                                : "assets/Icons/eye.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.secondaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                    RoundGradientButton(
                      title: "Login",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signIn(context, _emailController.text,
                              _passController.text);
                        }
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.01,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            height: 1,
                            color: AppColors.grayColor.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          " or ",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            height: 1,
                            color: AppColors.grayColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _handleSignIn,
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor1.withOpacity(0.5),
                                  width: 1,
                                )),
                            child: Image.asset(
                              "assets/Icons/google.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor1.withOpacity(0.5),
                                  width: 1,
                                )),
                            child: Image.asset(
                              "assets/Icons/facebook.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.01,
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => SignUpScreen()
                      ));
                    },
                        child: RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(text: "Don't have an account?  "),
                                TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                    color: AppColors.secondaryColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )
                                )
                              ],
                            ),
                        ),),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}