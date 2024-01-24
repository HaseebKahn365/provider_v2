import 'package:flutter/widgets.dart';

//lets create category class that will have list of activities. These activities will be displayed in the listview

class Category extends ChangeNotifier {
  final String name;
  List<Activity> activities = [];
  Category({required this.name});

  //add method to add to the list of activites
  void addActivity(Activity activity) {
    activities.add(activity);
    notifyListeners();
  }

  void clearActivities() {
    activities = [];
    notifyListeners();
  }

  void clearAt(int index) {
    activities.removeAt(index);
    notifyListeners();
  }
}

class Activity {
  final String name;
  final String description;
  Activity({required this.name, required this.description});
}

class Human extends ChangeNotifier {
  final String name;
  int age;
  Human({required this.name, this.age = 0});

  void increaseAge() {
    age++;
    notifyListeners();
  }
}
