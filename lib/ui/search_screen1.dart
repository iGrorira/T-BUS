// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String input = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search'),
            onChanged: (value) {
              setState(() {
                input = value;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (input.isEmpty) {
                      return ListTile(
                          title: Text(
                            data['product-name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(data['product-price'].toString()),
                          leading: Image.network(data['product-img'][0]));
                    }
                    if (data['product-name']
                        .toString()
                        .toLowerCase()
                        .startsWith(input.toLowerCase())) {
                      return ListTile(
                        title: Text(
                          data['product-name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data['product-price'].toString()),
                        leading: Image.network(data['product-img'][0]),
                      );
                    }
                    return Container();
                  });
        },
      ),
    );
  }
}
