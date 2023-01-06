import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reading_list/models/book_layout.dart';
import 'package:reading_list/utilities/constants.dart';
import 'package:reading_list/utilities/widgets.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  //collection reference
  final _favouritesCollectionReference = FirebaseFirestore.instance.collection('users');

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: _favouritesCollectionReference.doc(_firebaseAuth.currentUser!.uid).collection('favourites').orderBy('title').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

            //error
            if (snapshot.hasError || !snapshot.hasData){
              return firebaseStreamHasErrorMessage();
            }

            else{

              List<BookCard> _favBooks = [];

              for (var snpsht in snapshot.data!.docs){
                _favBooks.add(
                  BookCard(
                    title: snpsht.get('title'),
                    published: snpsht.get('published'),
                    plot: snpsht.get('plot'),
                    genre: snpsht.get('genre'),
                    author: snpsht.get('author'),
                    image: snpsht.get('image'),
                  ),
                );
              }

              return _favBooks.isEmpty ?

              kFirebaseStreamNoDataMessage //empty list
                  :
              GridView.builder(
                gridDelegate: kBookGridLayout,
                itemCount: _favBooks.length,
                itemBuilder: (context, index){

                  return GestureDetector(
                    child: _favBooks[index],

                    //remove from favourites
                    onLongPress: (){
                      QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

                      snapshotData.reference.delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        floatingSnackBar(
                          '${snapshotData.get('title')} successfully removed from favorites',
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
