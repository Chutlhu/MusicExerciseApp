import 'package:provider/provider.dart';
import 'package:bass_workout_app/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false)
      .initializeWorkoutsList();
  }


  // text controller
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );  
  }

  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
        ),
      ));
  }

  // save workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false)
      .addWorkout(newWorkoutName);
      
      // close the dialog
      Navigator.pop(context);
      clear();
  }
  
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear 
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
                'Bass Workout App',
                style: TextStyle(
                  color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF2e474c),
            elevation: 10,
            shadowColor: const Color(0xFF2e474c),
            leading: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.music_note,
                  color: Color(0xFFEB811B),
                ),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
              color: const Color(0xFFEB811B),
              height: 3.0,
            )),
          ),
          // backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            child: const Icon(Icons.add),
            ),
          body: ListView.builder(
            itemCount: value.getWorkoutsList().length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(value.getWorkoutsList()[index].name),
              trailing: IconButton(
                icon : Icon(Icons.arrow_forward_ios),
                onPressed: () => 
                  goToWorkoutPage(value.getWorkoutsList()[index].name),
              ),
            ),
          )
        );
      },
    );
  }
}