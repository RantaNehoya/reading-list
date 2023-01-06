import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reading_list/models/book_layout.dart';
import 'package:reading_list/utilities/constants.dart';
import 'package:reading_list/utilities/widgets.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({Key? key}) : super(key: key);

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  @override
  Widget build(BuildContext context) {

    //collection reference
    final _completedCollectionReference = FirebaseFirestore.instance.collection('users');

    //firebase auth
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Completed'),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: _completedCollectionReference.doc(_firebaseAuth.currentUser!.uid).collection('completed').orderBy('title').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

            //error
            if (snapshot.hasError || !snapshot.hasData){
              return firebaseStreamHasErrorMessage();
            }

            //filled list
            else{
              List<BookCard> completedBooks = [];

              for (var snpsht in snapshot.data!.docs){
                completedBooks.add(BookCard(
                  title: snpsht.get('title'),
                  published: snpsht.get('published'),
                  plot: snpsht.get('plot'),
                  genre: snpsht.get('genre'),
                  author: snpsht.get('author'),
                  image: snpsht.get('image'),
                ),);
              }

              return completedBooks.isEmpty ?

              kFirebaseStreamNoDataMessage
                  :
              GridView.builder(
                gridDelegate: kBookGridLayout,
                itemCount: completedBooks.length,
                itemBuilder: (context, index) {

                  return GestureDetector(
                    child: completedBooks[index],

                    onLongPress: (){
                      //delete from completed list
                      QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

                      snapshotData.reference.delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        floatingSnackBar(
                          '${snapshotData.get('title')} successfully removed from completed',
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
