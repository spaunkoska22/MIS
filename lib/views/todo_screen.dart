import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_reminder/models/ToDoItem.dart';
import 'package:on_the_go_reminder/services/camera_screen.dart';
import 'package:on_the_go_reminder/widgets/CreateNewToDoItem.dart';
import 'package:on_the_go_reminder/views/login_screen.dart';
import 'package:on_the_go_reminder/services/googlemaps.dart';
import 'package:on_the_go_reminder/views/calendar_screen.dart';
import 'package:on_the_go_reminder/services/notifications.dart';
import 'package:on_the_go_reminder/widgets/NotificationForm.dart';
import 'package:on_the_go_reminder/services/light_sensor.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final ScrollController controller = ScrollController();
  late final LocalNotificationsService service;
  late LightSensor _lightSensor;
  bool _notificationShown = false;

  @override
  void initState() {
    service = LocalNotificationsService();
    service.initialize();
    super.initState();

    // Create a LightSensor instance with a background color
    _lightSensor = LightSensor(
      backgroundColor: Colors.white,
      // Provide a background color here
      onLightLevelChanged: (double lightLevel) {
        // Show a notification if the light level is below a certain threshold
        if (!_notificationShown && lightLevel < 10) {
          service.showNotification(
            id: 0,
            title: 'Low light level detected!',
            body: 'The current light level is ${lightLevel.toStringAsFixed(2)}. Move to a lighter place to see better.',
          );
          _notificationShown = true;
        }
      },
    );

    _lightSensor.start();

  }

  @override
  void dispose() {
    _lightSensor.dispose();
    super.dispose();
  }

  final List<ToDoItem> _items = [
    ToDoItem(
      id: "1",
      title: "Dinner with family",
      date: DateTime.parse("2023-02-11 20:00:00"),
      location: "Leonardo Pizzeria",
      priority: 1,
    ),
    ToDoItem(
      id: "2",
      title: "Do Hair",
      date: DateTime.parse("2023-03-05 14:00:00"),
      location: "Hair Studio Elite",
      priority: 2,
    ),
    ToDoItem(
      id: "3",
      title: "Do Nails",
      date: DateTime.parse("2023-03-07 11:00:00"),
      location: "Perfecto Nails Studio",
      priority: 3,
    ),
    ToDoItem(
      id: "4",
      title: "Mum's Birthday",
      date: DateTime.parse("2023-03-25 00:00:00"),
      location: "Home",
      priority: 1,
    ),
    ToDoItem(
      id: "5",
      title: "Presentation in class",
      date: DateTime.parse("2023-04-10 09:50:00"),
      location: "Online",
      priority: 1,
    ),
    ToDoItem(
      id: "6",
      title: "Exam",
      date: DateTime.parse("2023-04-14 13:00:00"),
      location: "Online",
      priority: 1,
    ),
    ToDoItem(
      id: "7",
      title: "Wedding",
      date: DateTime.parse("2023-05-26 20:00:00"),
      location: "Hotel Alexander Palace",
      priority: 2,
    ),
  ];

  void _showModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: CreateNewToDoItem(_addNewToDoItem),
        );
      },
    );
  }

  void _addNewToDoItem(ToDoItem item) {
    setState(() {
      _items.add(item);
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  String _modifyDate(DateTime date) {
    String dateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> dateParts = dateString.split(" ");
    String modifiedTime = dateParts[1].substring(0, 5);
    return dateParts[0] + ' at ' + modifiedTime;
  }

  String _modifyLocation(String location) {
    return 'Location: ' + location;
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        print("User signed out");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LogInScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR HERE");
      print(e.message);
    }
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      title: const Text("On the Go Reminder"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _signOut,
        ),
      ],
    );
  }

  bool isChecked = false;
  int selectedIndex = 0;
  List<ToDoItem> selectedItems = [];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    print(selectedIndex);
    if (selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen(_items)),
      );
    } else if (selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    } else if (selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  Widget createBody(BuildContext context) {
    _items.sort((a, b) => a.priority.compareTo(b.priority));
    return Scaffold(
      floatingActionButton: Positioned(
        top: 60,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            _showModal(context);
          },
          backgroundColor: Colors.deepOrangeAccent,
          child: const Icon(Icons.add_task),
        ),
      ),
      body: Container(
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 20,
          radius: const Radius.circular(20),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: _items.isEmpty
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                          child: const Text(
                            "No more To-Do items",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                                fontSize: 25),
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _items.length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                title: Text(
                                  _items[index].title.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent),
                                ),
                                subtitle: Text(
                                  _modifyLocation(_items[index].location) +
                                      "\n" +
                                      _modifyDate(_items[index].date),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return const AlertDialog(
                                              title: Text('Set reminder'),
                                              content: NotificationForm(),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.notification_add),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Confirm Delete'),
                                              content: const Text(
                                                  'Are you sure you want to delete this item?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteToDoItem(
                                                        _items[index].id);
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    textStyle: const TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                    value:
                                        selectedItems.contains(_items[index]),
                                    onChanged: (value) {
                                      setState(() {
                                        if (selectedItems
                                            .contains(_items[index])) {
                                          selectedItems.remove(_items[index]);
                                        } else {
                                          selectedItems.add(_items[index]);
                                        }
                                      });
                                    }),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple[200],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey[900],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt),
            label: 'Location',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: createBody(context),
    );
  }
}
