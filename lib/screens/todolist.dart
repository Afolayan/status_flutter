import 'package:flutter_app/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:flutter_app/screens/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();

  int count = 0;
  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    //helper.insertRandomTodos();
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToDetail(Todo("", 3, ""));
        },
        tooltip: "Add new todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        int count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          this.count = count;
        });
        debugPrint("items $count");
      });
    });
  }

  ListView todoListItems() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          var todo = this.todos[position];
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(todo.priority),
                child: Text(todo.id.toString()),
              ),
              title: Text(todo.title),
              subtitle: Text(todo.date),
              onTap: () {
                debugPrint("Tapped on " + todo.toString());
                navigateToDetail(todo);
              },
            ),
          );
        },
        itemCount: count);
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo: todo)),
    );

    if(result){
      getData();
    }
  }
}
