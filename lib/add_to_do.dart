import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDo extends StatefulWidget {
  final List? items;
  final Map? todo;
  const AddToDo({super.key, this.todo, this.items});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['body'];
      titleController.text = title;
      descController.text = desc;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit List"),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: "Body",
              ),
            keyboardType:  TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            ),
           const SizedBox(
             height: 20,
           ),
           ElevatedButton(onPressed: updateData, child: const Text("Edit")),
          ],
        ),
      ),
    );
  }
  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You can not call updated without todo data");
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    final url = "https://jsonplaceholder.typicode.com/posts/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
          'Content-type': 'application/json; charset=UTF-8',
      });
    if (response.statusCode == 200) {
      titleController.text = '';
      descController.text = '';
      sucMessage('Update Success');
      setState(() {
        widget.items;
      });
    }
    else {
      sucMessage('Update Failed');
    }
  }

  Future<void> addData() async{
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    const url = "https://jsonplaceholder.typicode.com/posts";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      }
    );
    if (response.statusCode == 201) {
      titleController.text = '';
      descController.text = '';
      sucMessage('Creation Success');
    }
    else {
      sucMessage('Creation Failed');
    }
  }
  void sucMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}