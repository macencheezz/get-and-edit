import 'dart:convert';
import 'add_to_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key : key);


  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList>  {
    List items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,index){
              final item = items[index] as Map;
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['body']),
                trailing: PopupMenuButton(
                    onSelected: (value) {
                      if(value == 'edit') {
                        moveToEdit(item);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),),
                      ];
                    }
                ),
              );
           },
         ),
      ),
    );
  }
  void moveToEdit(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddToDo(todo:item,items:items),);
    await Navigator.push(context, route);
    getData();
  }
  Future<void> getData() async{
    const url = "https://jsonplaceholder.typicode.com/posts";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        items = json;
      });
    }else {

    }
  }
}