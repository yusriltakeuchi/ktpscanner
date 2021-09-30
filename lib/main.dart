
import 'package:flutter/material.dart';
import 'package:ktpscanner/core/viewmodels/scanner/scanner_provider.dart';
import 'package:ktpscanner/ui/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScannerProvider(),
      child: MaterialApp(
        title: 'KTP Scanner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}