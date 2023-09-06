import 'package:flutter/material.dart';
import 'package:taskmaster/models/database_handler.dart';
import 'package:taskmaster/models/item.dart';
import 'package:taskmaster/widgets/edit_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:taskmaster/widgets/date_navigator.dart';

final handler = DatabaseHandler();

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var currentDate = DateTime.now();

  void onDateChange(int difference) {
    setState(() {
      currentDate = currentDate.add(Duration(days: difference));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isToday;

    if (DateTime.now().year == currentDate.year &&
        DateTime.now().month == currentDate.month &&
        DateTime.now().day == currentDate.day) {
      isToday = true;
    } else {
      isToday = false;
    }

    return FutureBuilder(
        future: handler.fetchItems(),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!.where((item) {
              return item.date.year == currentDate.year &&
                  item.date.month == currentDate.month &&
                  item.date.day == currentDate.day;
            }).toList();
            return Scaffold(
              appBar: AppBar(
                title: const Text("Todo"),
              ),
              body: Column(
                children: [
                  DateNavigator(
                    currentDate: currentDate,
                    onDateChange: onDateChange,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        leading: items[index].done
                            ? const Icon(Icons.adjust)
                            : const Icon(Icons.circle_outlined),
                        title: Text(items[index].name),
                        trailing: isToday
                            ? GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        EditDialog(
                                      items[index],
                                      onItemDelete: (item) => setState(
                                        () {
                                          handler.deleteItem(items[index].id);
                                          snapshot.data!.remove(items[index]);
                                        },
                                      ),
                                      onItemSave: (item) => setState(
                                        () {
                                          handler.updateItem(item);
                                          snapshot.data![index] = item;
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.edit),
                              )
                            : null,
                        onTap: isToday
                            ? () => setState(() {
                                  items[index].done = !items[index].done;
                                  handler.updateItem(items[index]);
                                })
                            : null,
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: items.length,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => setState(() {
                  final newItem = Item(
                    id: const Uuid().v4(),
                    name: const Uuid().v4(),
                    done: false,
                    date: DateTime.now(),
                  );
                  snapshot.data!.add(newItem);
                  handler.insertItem(newItem);
                  currentDate = DateTime.now();
                }),
                tooltip: 'Increment Counter',
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
