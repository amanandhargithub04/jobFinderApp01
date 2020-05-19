import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobfinderapp01/ui/homepage/home_page.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_presenter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Job Finder App',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: new HomePage(new HomePagePresenter()),
    );
  }
}