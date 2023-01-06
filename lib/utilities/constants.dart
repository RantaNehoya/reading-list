import 'package:flutter/material.dart';

//auth page separators
const kAuthPageSeparator = SizedBox(
  height: 10.0,
);

//auth page heading
const kHeading = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
  color: Colors.white,
);

//auth page subheading
const kSubheading = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
);

const kFirebaseStreamNoDataMessage = Center(
  child: Text("Hmm... there seems to be nothing here"),
);

const kBottomSheetPadding = EdgeInsets.all(15.0);

const kBookGridLayout = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3/4.6,
);