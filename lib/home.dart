import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> teams = [];
  bool isLoading = true; // Track loading state

  // Request
  Future<void> getTeams() async {
    var url = Uri.https('www.balldontlie.io', '/api/v1/teams');
    var response = await http.get(url);
    final parsedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Successful
      setState(() {
        teams = parsedData["data"];
        isLoading = false; // Data loading complete
      });
    } else {
      print("Error: ${response.statusCode}");
      setState(() {
        isLoading = false; // Data loading failed
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA app"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : ListView.builder(
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                final team = teams[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        '${team["full_name"].toString()} (${team["abbreviation"].toString()})'),
                    subtitle: Text(team["city"].toString()),
                    tileColor: Color.fromARGB(147, 226, 230, 242),
                  ),
                );
              },
            ),
    );
  }
}
