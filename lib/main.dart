// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, sort_child_properties_last

import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_v2/model.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Human(name: 'Haseeb'),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Provider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        // Updated from 'fromSeed' to 'fromSwatch'
        // Also, 'useMaterial3' is deprecated and not needed in the latest versions
      ),
      home: const ProviderExample(),
    );
  }
}

class ProviderExample extends StatelessWidget {
  const ProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    //here we willl use multiprovider to provide multiple providers
    return MultiProvider(
      providers: [
        //here we will provide two providers
        ChangeNotifierProvider<Human>(
          create: (context) => Human(name: 'Haseeb'),
        ),
        ChangeNotifierProvider<Category>(
          create: (context) => Category(
            name: 'Sports',
          ),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Provider Example'),
            Text("No. ${Provider.of<Category>(context, listen: true).activities.length}"),
          ],
        ),
      ),
      body: Center(child: mainBody()),
    );
  }
}

class mainBody extends StatefulWidget {
  const mainBody({
    super.key,
  });

  @override
  State<mainBody> createState() => _mainBodyState();
}

class _mainBodyState extends State<mainBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Name of category: ${Provider.of<Category>(context, listen: false).name}',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Name of human: ${Provider.of<Human>(context, listen: false).name}, age: ${Provider.of<Human>(context, listen: true).age}',
          style: TextStyle(fontSize: 20),
        ),

        ElevatedButton(
          onPressed: () {
            context.read<Human>().increaseAge();
          },
          child: Text('Increase age'),
        ),

        //button to add activity
        ElevatedButton(
          onPressed: () {
            context.read<Category>().addActivity(
                  Activity(
                    name: 'Football',
                    description: 'Play football',
                  ),
                );
            if (Provider.of<Category>(context, listen: false).activities.length > 21) {
              //empty the activities list
              Provider.of<Category>(context, listen: false).activities = [];
            }
            if (context.read<Category>().activities.length > 20) {
              //navigate to the new screen using material route

              Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));
            }
          },
          child: Text('Add activity'),
        ),

        //listview to display activities
        Expanded(
          child: Container(
              height: 200,
              child: AnimationList(
                children: Provider.of<Category>(context, listen: true)
                    .activities
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Card(
                            child: ListTile(
                              title: Text(e.name),
                              subtitle: Text(e.description),
                              trailing: IconButton(
                                onPressed: () {
                                  context.read<Category>().clearAt(Provider.of<Category>(context, listen: false).activities.indexOf(e));
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                            elevation: 20,
                          ),
                        ))
                    .toList(),
                physics: BouncingScrollPhysics(),
                duration: 2,
                reBounceDepth: 3,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                addSemanticIndexes: true,
              )),
        ),
      ],
    );
  }
}

//new screen

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    String name = Provider.of<Human>(context, listen: false).name;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: ListView.builder(
        itemCount: 21,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(name),
                subtitle: Text(name),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
              ),
              elevation: 20,
            ),
          );
        },
      ),
    );
  }
}
