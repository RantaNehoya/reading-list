import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/utilities/widgets.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {

  String newEmail = '';

  final _formKey = GlobalKey<FormState>();

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _){
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),

            body: Column(
              children: [

                //user details
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: theme.isDark ? AppTheme.darkMode.primaryColorLight : AppTheme.lightMode.primaryColorLight,

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image(
                              image: const AssetImage('assets/images/img.png'),
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                          ),

                          Container(
                            color: theme.isDark ? AppTheme.darkMode.colorScheme.secondary : AppTheme.lightMode.colorScheme.secondary,

                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _firebaseAuth.currentUser!.email.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        //change email
                        settingsPageOptions(
                          label: 'Change Email',
                          icon: Icons.email_outlined,
                          function: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey
                                    ,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        label: Text('New Email'),
                                      ),

                                      validator: (value){
                                        if (value == null || value.isEmpty){
                                          return 'Cannot leave field empty';
                                        }
                                        else {
                                          return null;
                                        }
                                      },

                                      onEditingComplete: (){
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },

                                      onChanged: (value){
                                        newEmail = value;
                                      },
                                    ),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        //change email
                                        if (_formKey.currentState!.validate()){
                                          setState((){
                                            _firebaseAuth.currentUser!.updateEmail(newEmail);
                                          });
                                          Navigator.pop(context);
                                        }
                                      },

                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                        //change password
                        settingsPageOptions(
                          label: 'Change Password',
                          icon: Icons.password_outlined,
                          function: (){
                            _firebaseAuth.sendPasswordResetEmail(
                              email: _firebaseAuth.currentUser!.email.toString(),
                            );

                            floatingSnackBar('Password reset sent to email address');
                          },
                        ),

                        //log out
                        settingsPageOptions(
                          label: 'Log Out',
                          icon: Icons.logout_outlined,
                          function: (){
                            _firebaseAuth.signOut();
                            Navigator.popAndPushNamed(
                              context, '/',
                            );
                          },
                        ),

                        settingsPageDivider(context),

                        //change to light mode
                        settingsPageOptions(
                          label: 'Light Mode',
                          icon: Icons.light_mode_outlined,
                          function: (){
                            //isDark = false
                            theme.changeTheme(false);
                          },
                        ),

                        //change to dark mode
                        settingsPageOptions(
                          label: 'Dark Mode',
                          icon: Icons.dark_mode_outlined,
                          function: (){
                            //isDark = true
                            theme.changeTheme(true);
                          },
                        ),

                        settingsPageDivider(context),

                        //delete account
                        settingsPageOptions(
                          label: 'Delete Account',
                          icon: Icons.delete_outlined,
                          function: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  actionsAlignment: MainAxisAlignment.spaceAround,
                                  content: const Text('Do you wish to delete your account?\nThis action is irreversible'),

                                  actions: [
                                    //yes
                                    OutlinedButton(
                                      onPressed: () async {

                                        //delete user account
                                        await _firebaseAuth.currentUser!.delete();

                                        Navigator.popAndPushNamed(
                                          context, '/',
                                        );
                                      },

                                      child: const Text('Yes'),
                                    ),

                                    //no
                                    OutlinedButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },

                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
