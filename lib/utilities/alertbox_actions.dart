import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reading_list/utilities/widgets.dart';
import 'package:reading_list/utilities/utilities.dart';


//edit book
// class EditBook extends StatefulWidget {
//
//   final AsyncSnapshot<QuerySnapshot> snapshot;
//   final int index;
//
//   const EditBook({
//     Key? key,
//     required this.snapshot,
//     required this.index,
//   }) : super(key: key);
//
//   @override
//   State<EditBook> createState() => _EditBookState();
// }
//
// class _EditBookState extends State<EditBook> {
//   final _formKey = GlobalKey<FormState>();
//
//   bool _isDateSelected = false;
//   DateTime _selectedDate = DateTime.now();
//
//   //controllers
//   final  TextEditingController _title = TextEditingController();
//   final  TextEditingController _author = TextEditingController();
//   final  TextEditingController _genre = TextEditingController();
//   final  TextEditingController _plot = TextEditingController();
//
//   //focus nodes
//   final FocusNode _authorFocusNode = FocusNode();
//   final FocusNode _genreFocusNode = FocusNode();
//   final FocusNode _plotFocusNode = FocusNode();
//
//   //date picker method
//   _selectDate (BuildContext ctx) async {
//     final DateTime? selected = await showDatePicker(
//       context: ctx,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1650),
//       lastDate: DateTime(DateTime.now().year + 1),
//     );
//
//     if (selected != null && selected != _selectedDate){
//       _selectedDate = selected;
//       _isDateSelected = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     //dispose controllers
//     _title.dispose();
//     _author.dispose();
//     _genre.dispose();
//     _plot.dispose();
//
//     //dispose focus nodes
//     _authorFocusNode.dispose();
//     _genreFocusNode.dispose();
//     _plotFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return bookOption(
//       action: 'Edit Book',
//       ctx: context,
//
//       function: (){
//         // Navigator.pop(context);
//         QueryDocumentSnapshot snapshotData = widget.snapshot.data!.docs[widget.index];
//
//         _title.text = snapshotData.get('title');
//         _author.text = snapshotData.get('author');
//         _genre.text = snapshotData.get('genre');
//         _plot.text = snapshotData.get('plot');
//         _selectedDate = DateTime.parse(snapshotData.get('published'));
//
//
//
//         showModalBottomSheet(
//           isScrollControlled: true,
//           context: context,
//
//           builder: (context){
//             return Consumer<ThemeProvider>(
//               builder: (context, theme, _){
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.9,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//
//                             //title
//                             bookInputTextFormField(
//                               label: 'Title',
//                               controller: _title,
//                               requestedFocusNode: _authorFocusNode,
//                             ),
//
//                             //author
//                             bookInputTextFormField(
//                               label: 'Author',
//                               controller: _author,
//                               focusNode: _authorFocusNode,
//                               requestedFocusNode: _genreFocusNode,
//                             ),
//
//                             //genre
//                             bookInputTextFormField(
//                               label: 'Genre',
//                               controller: _genre,
//                               focusNode: _genreFocusNode,
//                               requestedFocusNode: _plotFocusNode,
//                             ),
//
//                             //plot
//                             bookInputTextFormField(
//                               label: 'Plot',
//                               controller: _plot,
//                               focusNode: _plotFocusNode,
//                             ),
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//
//                                 //date published
//                                 GestureDetector(
//                                   onTap: (){
//                                     _selectDate(context);
//                                   },
//
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width * 0.5,
//                                     height: MediaQuery.of(context).size.height * 0.07,
//
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       border: Border.all(
//                                         color: theme.isDark ? Colors.white54 : Colors.black54,
//                                         width: 1.0,
//                                       ),
//                                     ),
//
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//
//                                         children: [
//                                           Icon(
//                                             Icons.today_outlined,
//                                             color: theme.isDark ? Colors.white54 : Colors.black54,
//                                           ),
//
//                                           Text(
//                                             '${_selectedDate.day} - ${_selectedDate.month} - ${_selectedDate.year}',
//                                             style: TextStyle(
//                                               color: theme.isDark ? Colors.white54 : Colors.black54,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 //book function button
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     primary: theme.isDark ? AppTheme.darkMode.colorScheme.secondary : AppTheme.lightMode.colorScheme.secondary,
//                                   ),
//
//                                   child: Text(
//                                     'Update Book',
//                                     style: TextStyle(
//                                       color: theme.isDark ? Colors.white : Colors.black,
//                                     ),
//                                   ),
//
//                                   onPressed: (){
//
//                                     if(_formKey.currentState!.validate()){
//
//                                       snapshotData.reference.set({
//                                         'image': '',
//                                         'title': _title.text,
//                                         'author': _author.text,
//                                         'genre': _genre.text,
//                                         'plot': _plot.text,
//                                         'published': _selectedDate.toString(),
//                                       });
//
//                                       Navigator.pop(context);
//
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         floatingSnackBar(
//                                           'Book successfully updated',
//                                         ),
//                                       );
//                                     }
//
//                                     //unfocus keyboard
//                                     FocusManager.instance.primaryFocus?.unfocus();
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//
//
//
//
//             //   BottomsheetMenu(
//             //   buttonLabel: 'Update Book',
//             //   title: _title,
//             //   author: _author,
//             //   genre: _genre,
//             //   plot: _plot,
//             //   datePublished: _datePublished,
//             //
//             //   authorFocusNode: _authorFocusNode,
//             //   genreFocusNode: _genreFocusNode,
//             //   plotFocusNode: _plotFocusNode,
//             //
//             //   function:
//             // );
//
//
//             //   Consumer<ThemeProvider>(
//             //   builder: (context, theme, _){
//             //     return SingleChildScrollView(
//             //       child: SizedBox(
//             //         height: bottomSheetHeight(context),
//             //         child: Padding(
//             //           padding: kBottomSheetPadding,
//             //           child: Form(
//             //             key: _formKey,
//             //             child: Column(
//             //               children: [
//             //
//             //                 //title
//             //                 bookInputTextFormField(
//             //                   label: 'Title',
//             //                   controller: _title,
//             //                   requestedFocusNode: _authorFocusNode,
//             //                 ),
//             //
//             //                 //author
//             //                 bookInputTextFormField(
//             //                   label: 'Author',
//             //                   controller: _author,
//             //                   focusNode: _authorFocusNode,
//             //                   requestedFocusNode: _genreFocusNode,
//             //                 ),
//             //
//             //                 //genre
//             //                 bookInputTextFormField(
//             //                   label: 'Genre',
//             //                   controller: _genre,
//             //                   focusNode: _genreFocusNode,
//             //                   requestedFocusNode: _plotFocusNode,
//             //                 ),
//             //
//             //                 //plot
//             //                 bookInputTextFormField(
//             //                   label: 'Plot',
//             //                   controller: _plot,
//             //                   focusNode: _plotFocusNode,
//             //                 ),
//             //
//             //                 Row(
//             //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //                   children: [
//             //
//             //                     //date published
//             //                     GestureDetector(
//             //                       onTap: () async {
//             //                         await _selectDate(context);
//             //                         _datePublished = _selectedDate;
//             //                       },
//             //
//             //                       child: Container(
//             //                         width: publicationDateWidth(context),
//             //                         height: publicationDateHeight(context),
//             //
//             //                         decoration: BoxDecoration(
//             //                           borderRadius: BorderRadius.circular(8.0),
//             //                           border: Border.all(
//             //                             color: theme.isDark ? Colors.white54 : Colors.black54,
//             //                             width: 1.0,
//             //                           ),
//             //                         ),
//             //
//             //                         child: Padding(
//             //                           padding: const EdgeInsets.all(8.0),
//             //                           child: Row(
//             //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //
//             //                             children: [
//             //                               Icon(
//             //                                 Icons.today_outlined,
//             //                                 color: theme.isDark ? Colors.white54 : Colors.black54,
//             //                               ),
//             //
//             //                               Text(
//             //                                 '${_selectedDate.year} - ${_selectedDate.month} - ${_selectedDate.day}',
//             //
//             //                                 style: TextStyle(
//             //                                   color: theme.isDark ? Colors.white54 : Colors.black54,
//             //                                 ),
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ),
//             //                     ),
//             //
//             //                     //update book button
//             //                     ElevatedButton(
//             //                       style: ElevatedButton.styleFrom(
//             //                         primary: theme.isDark ? AppTheme.darkMode.colorScheme.secondary : AppTheme.lightMode.colorScheme.secondary,
//             //                       ),
//             //
//             //                       child: Text(
//             //                         'Update Book',
//             //                         style: TextStyle(
//             //                           color: theme.isDark ? Colors.white : Colors.black,
//             //                         ),
//             //                       ),
//             //
//             //                       onPressed:
//             //                     ),
//             //                   ],
//             //                 ),
//             //               ],
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // );
//           },
//         );
//
//         // Navigator.pop(context);
//         //
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   floatingSnackBar(
//         //     '${snapshotData.get('title')} successfully completed',
//         //   ),
//         // );
//       },
//     );
//   }
// }

//remove books
class RemoveBook extends StatelessWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  const RemoveBook({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Remove',
      ctx: context,
      function: (){
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context){
            return AlertBox( //yes option
              function: (){

                snapshot.data!.docs[index].reference.delete();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  floatingSnackBar('Book successfully deleted'),
                );
              },
            );
          },
        );
      },
    );
  }
}

//add to favourites
class AddToFavourites extends StatelessWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  AddToFavourites({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Add to Favourites',
      ctx: context,

      function: (){
        QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

        //TODO: DUPLICATES
        _reference.doc(_firebaseAuth.currentUser!.uid).collection('favourites').add({
          'image': snapshotData.get('image'),
          'title': snapshotData.get('title'),
          'author': snapshotData.get('author'),
          'genre': snapshotData.get('genre'),
          'plot': snapshotData.get('plot'),
          'published': snapshotData.get('published'),
        });

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            '${snapshotData.get('title')} successfully added to favorites',
          ),
        );
      },
    );
  }
}

//send to completed
class SendToCompleted extends StatelessWidget {


  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  SendToCompleted({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Send to Completed',
      ctx: context,

      function: (){
        QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

        //add to completed list
        _reference.doc(_firebaseAuth.currentUser!.uid).collection('completed').add({
          'image': snapshotData.get('image'),
          'title': snapshotData.get('title'),
          'author': snapshotData.get('author'),
          'genre': snapshotData.get('genre'),
          'plot': snapshotData.get('plot'),
          'published': snapshotData.get('published'),
        });

        //delete book from reading list
        snapshotData.reference.delete();

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            '${snapshotData.get('title')} successfully completed',
          ),
        );
      },
    );
  }
}