class Item {
  final String id;
  String name;
  bool done;
  final DateTime date;

  Item(
      {required this.id,
      required this.name,
      required this.done,
      required this.date});

  Item.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        done = (res['done'] == 1) ? true : false,
        date = DateTime.parse(res['date']);

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'done': done ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }
}
