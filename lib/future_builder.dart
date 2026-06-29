import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  // CATATAN: Jika pakai emulator Android, ganti localhost jadi 10.0.2.2
  final String url = "http://10.0.2.2/api_flutter/read.php";

  Future getList() async {
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data MySQL")),
      body: FutureBuilder(
        future: getList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index]['nama']),
                  subtitle: Text(snapshot.data[index]['email']),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}