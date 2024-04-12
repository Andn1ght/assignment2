import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List App',
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<ListItem> items = [];

  void addItem(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController groupController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the modal is scrollable
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(controller: idController, decoration: InputDecoration(labelText: 'ID')),
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextField(controller: groupController, decoration: InputDecoration(labelText: 'Group')),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (idController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          groupController.text.isNotEmpty) {
                        String newItemId = idController.text;
                        bool idExists = items.any((item) => item.id == newItemId);
                        if (idExists) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Warning'),
                                content: Text('An item with the same ID already exists. Do you want to substitute it?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('Substitute'),
                                    onPressed: () {
                                      setState(() {
                                        items.removeWhere((item) => item.id == newItemId);
                                        items.add(ListItem(
                                          id: newItemId,
                                          name: nameController.text,
                                          group: groupController.text,
                                        ));
                                      });
                                      Navigator.pop(context); // Close the add modal
                                      Navigator.pop(context); // Close the warning dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          setState(() {
                            items.add(ListItem(
                              id: newItemId,
                              name: nameController.text,
                              group: groupController.text,
                            ));
                          });
                          Navigator.pop(context);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editItem(BuildContext context, ListItem item) {
    TextEditingController idController = TextEditingController(text: item.id);
    TextEditingController nameController = TextEditingController(text: item.name);
    TextEditingController groupController = TextEditingController(text: item.group);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the modal is scrollable
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(controller: idController, decoration: InputDecoration(labelText: 'ID')),
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextField(controller: groupController, decoration: InputDecoration(labelText: 'Group')),
                  ElevatedButton(
                    child: Text('Update'),
                    onPressed: () {
                      setState(() {
                        item.id = idController.text;
                        item.name = nameController.text;
                        item.group = groupController.text;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteItem(BuildContext context, ListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  items.remove(item);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Items'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          ListItem item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.group),
            onTap: () => editItem(context, item),
            onLongPress: () => deleteItem(context, item),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItem(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListItem {
  String id;
  String name;
  String group;

  ListItem({required this.id, required this.name, required this.group});
}
