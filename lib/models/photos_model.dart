import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotosModel extends StatefulWidget {
  const PhotosModel({super.key});

  @override
  State<PhotosModel> createState() => _HomescreenState();
}

class _HomescreenState extends State<PhotosModel> {
  List<Photos> photosList = [];

  Future<List<Photos>> getPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in data) {
        Photos photos = Photos(url: i['url'], title: i['title'], id: i['id']);
        photosList.add(photos);
      }
      return photosList;
    } else {
      return photosList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder(
        future: getPhotos(),
        builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading');
          } else {
            return ListView.builder(
              itemCount: photosList.length,
              itemBuilder: (context, index) {
                return ListTile(

                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data![index].url.toString()),
                    
                    ),
                    title: Text(snapshot.data![index].title.toString()),
                    subtitle: Text('ID: ${snapshot.data![index].id}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Photos {
  String url, title;
  int id;
  Photos({required this.url, required this.title, required this.id});
}