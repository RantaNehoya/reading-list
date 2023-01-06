import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/utilities/widgets.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  //book image
  File? _bookImage;
  String _selectedImage = '';

  //collection reference
  final _collectionReference = FirebaseFirestore.instance.collection('users');

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isDateSelected = false;
  DateTime _selectedDate = DateTime.now();

  //controllers
  final TextEditingController _title = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _genre = TextEditingController();
  final TextEditingController _plot = TextEditingController();

  //focus nodes
  final FocusNode _authorFocusNode = FocusNode();
  final FocusNode _genreFocusNode = FocusNode();
  final FocusNode _plotFocusNode = FocusNode();

  //date picker method
  _selectDate (BuildContext ctx) async {
    final DateTime? selected = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(1650),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (selected != null && selected != _selectedDate){
      _selectedDate = selected;
      _isDateSelected = true;
    }
  }

  Future<String> _imageFromGallery () async {

    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState((){
      _bookImage = File(imageFile!.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage = await (File(imageFile.path)).copy('${appDir.path}/$fileName');

    return savedImage.path;
  }

  @override
  void dispose() {
    //dispose controllers
    _title.dispose();
    _author.dispose();
    _genre.dispose();
    _plot.dispose();

    //dispose focus nodes
    _authorFocusNode.dispose();
    _genreFocusNode.dispose();
    _plotFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _){
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    //book image
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _bookImage != null ?
                        Image.file(
                          _bookImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ) :
                        const Text('Select Image'),
                      ),

                      //select image from gallery
                      onTap: () async {
                        _selectedImage = await _imageFromGallery();
                      },
                    ),

                    //title
                    bookInputTextFormField(
                      label: 'Title',
                      controller: _title,
                      requestedFocusNode: _authorFocusNode,
                    ),

                    //author
                    bookInputTextFormField(
                      label: 'Author',
                      controller: _author,
                      focusNode: _authorFocusNode,
                      requestedFocusNode: _genreFocusNode,
                    ),

                    //genre
                    bookInputTextFormField(
                      label: 'Genre',
                      controller: _genre,
                      focusNode: _genreFocusNode,
                      requestedFocusNode: _plotFocusNode,
                    ),

                    //plot
                    bookInputTextFormField(
                      label: 'Plot',
                      controller: _plot,
                      focusNode: _plotFocusNode,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        //date published
                        GestureDetector(
                          onTap: (){
                            _selectDate(context);
                          },

                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.07,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: theme.isDark ? Colors.white54 : Colors.black54,
                                width: 1.0,
                              ),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,

                                children: [
                                  Icon(
                                    Icons.today_outlined,
                                    color: theme.isDark ? Colors.white54 : Colors.black54,
                                  ),

                                  Text(
                                    _isDateSelected ? '${_selectedDate.day} - ${_selectedDate.month} - ${_selectedDate.year}': 'Choose Date',
                                    style: TextStyle(
                                      color: theme.isDark ? Colors.white54 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //book function button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.isDark ? AppTheme.darkMode.colorScheme.secondary : AppTheme.lightMode.colorScheme.secondary,
                          ),

                          child: Text(
                            'Add Book',
                            style: TextStyle(
                              color: theme.isDark ? Colors.white : Colors.black,
                            ),
                          ),

                          onPressed: (){

                            if(_formKey.currentState!.validate() && _isDateSelected){
                              _collectionReference.doc(_firebaseAuth.currentUser!.uid).collection('books').add({
                                'image': _selectedImage,
                                'title': _title.text,
                                'author': _author.text,
                                'genre': _genre.text,
                                'plot': _plot.text,
                                'published': _selectedDate.toString(),
                              });

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                floatingSnackBar(
                                  'Book successfully added',
                                ),
                              );
                            }

                            //unfocus keyboard
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
