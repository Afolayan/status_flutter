import 'package:flutter/material.dart';
import 'package:flutter_app/model/todo.dart';
import 'package:flutter_app/screens/todolist.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper dbHelper = DbHelper();

final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const menuSave = 'Save Todo & Back';
const menuDelete = 'Delete Todo';
const menuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  TodoDetail({Key key, this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<StatefulWidget> createState() => TodoDetailState();
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  String _priority = "Low";
  final _priorities = ["High", "Medium", "Low"];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    todo = widget.todo;
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true, //does not show the back button
            title: Text(todo.title),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: select,
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ]),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, bottom: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    buildTextField(textStyle, "Title", titleController),
                    buildTextField(
                        textStyle, "Description", descriptionController),
                    ListTile(
                        title: DropdownButton<String>(
                      items: _priorities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriority(todo.priority),
                      onChanged: (String value) => updatePriority(value),
                    ))
                  ],
                ),
              ],
            )));
  }


  Padding buildTextField(
      TextStyle textStyle, String title, TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextField(
          controller: controller,
          onChanged: (value) => updateField(controller),
          style: textStyle,
          decoration: InputDecoration(
              labelText: title,
              labelStyle: textStyle,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        }
        result = await dbHelper.deleteTodo(todo.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      dbHelper.updateTodo(todo);
    } else {
      dbHelper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value){
    switch(value){
      case "High":
        todo.priority = 1;
        break;
    case "Medium":
        todo.priority = 2;
        break;
    case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }
  String getPriority(int priority){
    return _priorities[priority -1];
  }

  void updateTitle(){
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void updateField(TextEditingController controller) {
    if(controller == titleController) updateTitle();
    else updateDescription();
  }
}
