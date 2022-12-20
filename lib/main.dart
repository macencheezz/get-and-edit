import 'package:flutter/material.dart';
import 'to_do_list.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    title: "Semi-Final Exam",
    home: const TodoList()
    )
  );
}