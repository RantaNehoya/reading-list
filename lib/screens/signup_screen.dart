import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/utilities/constants.dart';
import 'package:reading_list/utilities/widgets.dart';

import '../models/privacy_policy.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _cpIsObscured = true;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  //controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  //focuse nodes
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {

    //dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    //dispose focus nodes
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightMode.primaryColor,

      body: Column(
        children: [

          //sign up
          Expanded(
            flex: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        'Welcome to Reading List',
                        style: kHeading,
                      ),

                      kAuthPageSeparator,

                      const Text(
                        'A place to log all your reading books.\nLet\'s get started!',
                        textAlign: TextAlign.center,
                        style: kSubheading,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [

                              //email
                              authPageInput(
                                label: 'Email',
                                icon: Icons.email,
                                inputType: TextInputType.emailAddress,

                                controller: _emailController,

                                function: (){
                                  _passwordFocusNode.requestFocus();
                                },
                              ),

                              kAuthPageSeparator,

                              //password
                              authPageInput(
                                label: 'Password',
                                obscureTxt: _isObscured,
                                icon: Icons.password_outlined,
                                suffIcon: IconButton(

                                  icon: _isObscured ? const Icon(
                                    Icons.visibility_outlined,
                                  ) : const Icon(
                                    Icons.visibility_off_outlined,
                                  ),

                                  onPressed: (){
                                    setState(() {
                                      _isObscured = _isObscured ? false : true;
                                    });
                                  },
                                ),

                                controller: _passwordController,
                                focusNode: _passwordFocusNode,

                                function: (){
                                  _confirmPasswordFocusNode.requestFocus();
                                },
                              ),

                              kAuthPageSeparator,

                              //confirm password
                              authPageInput(
                                label: 'Confirm Password',
                                obscureTxt: _cpIsObscured,
                                icon: Icons.password_outlined,

                                suffIcon: IconButton(

                                  icon: _cpIsObscured ? const Icon(
                                    Icons.visibility_outlined,
                                  ) : const Icon(
                                    Icons.visibility_off_outlined,
                                  ),

                                  onPressed: (){
                                    setState(() {
                                      _cpIsObscured = _cpIsObscured ? false : true;
                                    });
                                  },
                                ),

                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,

                                function: (){
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),

                              kAuthPageSeparator,
                              kAuthPageSeparator,
                              kAuthPageSeparator,

                              RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: const TextStyle(
                                    fontFamily: 'Dosis',
                                  ),

                                  children: [
                                    TextSpan(
                                      text: 'Log in',
                                      style: const TextStyle(
                                        fontFamily: 'Dosis',
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),

                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.popAndPushNamed(
                                            context, '/login',
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),

                              kAuthPageSeparator,

                              //button
                              ModalProgressHUD(
                                inAsyncCall: _isLoading,

                                child: OutlinedButton(
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),

                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * 0.2,
                                      vertical: MediaQuery.of(context).size.height * 0.02,
                                    ),
                                  ),

                                  onPressed: () async {
                                    if(!(_formKey.currentState!.validate())){
                                      //pass
                                    };

                                    //password and confirm password match
                                    if(_passwordController.text == _confirmPasswordController.text){
                                      _isLoading = true;

                                      try {

                                        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );

                                        User? user = userCredential.user;

                                        if (user != null){
                                          String docID = user.uid;

                                          //create default starter book
                                          _collectionReference.doc(docID).collection('books').doc().set({
                                            'image': '',
                                            'title': 'new book',
                                            'author': 'author',
                                            'genre': 'genre',
                                            'plot': 'plot',
                                            'published': DateTime.now().toString(),
                                          });

                                          _isLoading = false;

                                          Navigator.popAndPushNamed(
                                            context, '/navigator',
                                          );
                                        }
                                      }

                                      on FirebaseAuthException catch (e){
                                        _isLoading = false;

                                        if (e.code == 'email-already-in-use'){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            floatingSnackBar(
                                              'Email already in use',
                                            ),
                                          );
                                        }
                                        else if (e.code == 'internal-error'){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            floatingSnackBar(
                                              'An error occurred',
                                            ),
                                          );
                                        }
                                        else if (e.code == 'invalid-email'){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            floatingSnackBar(
                                              'Invalid email',
                                            ),
                                          );
                                        }
                                        else if (e.code == 'invalid-password'){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            floatingSnackBar(
                                              'Password must be at least 6 characters long',
                                            ),
                                          );
                                        }
                                      }

                                      on Exception {
                                        _isLoading = false;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          floatingSnackBar(
                                            'An error occurred',
                                          ),
                                        );
                                      }
                                    }

                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        floatingSnackBar(
                                          'Passwords don\'t match',
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //view privacy policy
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),

              child: Container(
                alignment: Alignment.bottomCenter,

                child: RichText(
                  text: TextSpan(
                    text: 'View our ',
                    style: const TextStyle(
                      fontFamily: 'Dosis',
                    ),

                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),

                        recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return const PrivacyPolicy();
                              },
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
