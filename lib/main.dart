import 'package:election_exit_poll_620710313/pages/candidate_list.dart';
import 'package:election_exit_poll_620710313/pages/candidate_poll.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        CandidatePage.routeName: (context) => const CandidatePage(),
        CandidatePoll.routeName: (context) => const CandidatePoll(),
      },
      initialRoute: CandidatePage.routeName,
    );
  }
}


