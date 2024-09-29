import 'dart:convert';
import 'models/postModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<PostModel> postList = [];

  Future<List<PostModel>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      postList = data.map((post) => PostModel.fromJson(post)).toList();
      return postList;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder(
        future: getPostApi(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading');
          } else {
            return ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        postList[index].title.toString(),
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        postList[index].body.toString(),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
