import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:reading_list/utilities/widgets.dart';
import 'package:reading_list/app_theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void newScreen() async {
    try {
      final result = await InternetAddress.lookup('www.google.com'); //check internet connection
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.popAndPushNamed(
          context,
          '/signup',
        );
      }
    }
    on SocketException catch (_) { //no internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar(
          'Internet connection needed',
        ),
      );
    }
  }

  @override
  void initState() {
    newScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightMode.primaryColor,

      body: const Center(
        child: SpinKitDoubleBounce(
          color: Colors.white54,
        ),
      ),
    );
  }
}
