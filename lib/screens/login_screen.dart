import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/utilities/constants.dart';
import 'package:reading_list/utilities/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //focus nodes
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {

    //dispose controllers
    _emailController.dispose();
    _passwordController.dispose();

    //dispose focus nodes
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightMode.primaryColor,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text(
                  'Reading List',
                  style: kHeading,
                ),

                kAuthPageSeparator,

                const Text(
                  'A place to log all your reading books.\nWelcome back!',
                  textAlign: TextAlign.center,
                  style:kSubheading,
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
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),

                        kAuthPageSeparator,
                        kAuthPageSeparator,
                        kAuthPageSeparator,

                        RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: const TextStyle(
                              fontFamily: 'Dosis',
                            ),

                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: const TextStyle(
                                  fontFamily: 'Dosis',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),

                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Navigator.popAndPushNamed(
                                      context, '/',
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),

                        kAuthPageSeparator,

                        ModalProgressHUD(
                          inAsyncCall: _isLoading,
                          child: OutlinedButton(
                            child: const Text(
                              'Log in',
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
                              _isLoading = true;

                              try {

                                UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                User? user = userCredential.user;

                                if (user != null){
                                  _isLoading = false;

                                  Navigator.popAndPushNamed(
                                    context, '/navigator',
                                  );
                                }
                              }

                              on FirebaseAuthException catch (e){
                                _isLoading = false;

                                if (e.code == 'internal-error'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    floatingSnackBar(
                                      'An error occurred',
                                    ),
                                  );
                                }
                                else if (e.code == 'wrong-password'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    floatingSnackBar(
                                      'Incorrect password',
                                    ),
                                  );
                                }
                                else if (e.code == 'user-not-found'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    floatingSnackBar(
                                      'User not found',
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
    );
  }
}
