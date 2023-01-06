import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class BookCard extends StatelessWidget {

  final String image;
  final String title;
  final String author;
  final String published;
  final String genre;
  final String plot;

  const BookCard({
    Key? key,
    required this.image,
    required this.title,
    required this.author,
    required this.published,
    required this.genre,
    required this.plot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[

          Image(
            image: (image.isEmpty || image == null) ?
            const AssetImage('assets/images/undefined.png')
                : FileImage(File(image)) as ImageProvider,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.23,
          ),

          ...List.generate(
            1, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),

              child: Column(
                children: <Widget>[
                  Text(
                    "$title - $author",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    DateFormat.yMMMMd().format(DateTime.parse(published)).toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),

                  Text(
                    genre,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            );
          },),
        ],
      ),
    );
  }
}