import 'package:bass_workout_app/components/exercise_tile.dart';
import 'package:bass_workout_app/data/workout_data.dart';
import 'package:bass_workout_app/models/exercise.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
      .checkoffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final tempoController = TextEditingController();
  final chordsController = TextEditingController();
  final descriptionController = TextEditingController();
  final playbackAudioFileController = TextEditingController();

  var randomExercisetHistory = <String>[];

  void createNewExercise() {
    showDialog(
      context: context, 
      builder: (contex) => AlertDialog(
        title: Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: exerciseNameController,
              decoration: InputDecoration(
                labelText: 'Exercise Name',
              ),
            ),
            TextField(
              controller: tempoController,
              decoration: InputDecoration(
                labelText: 'Tempo',
              ),
            ),
            TextField(
              controller: chordsController,
              decoration: InputDecoration(
                labelText: 'Chords',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: playbackAudioFileController,
              decoration: InputDecoration(
                labelText: 'Playback Audio File',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  
  void getRandomExercise() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(
          Provider.of<WorkoutData>(context, listen: false)
            .getRandomExercise(widget.workoutName)
            .name,
        ),
        content: Text(
          Provider.of<WorkoutData>(context, listen: false)
            .getRandomExercise(widget.workoutName)
            .description,
        ),
        actions: [
          MaterialButton(
            onPressed: () {},
            child: const Text('Next'),
          ),
          MaterialButton(
            onPressed: () {},
            child: const Text('Done'),
          ),
          MaterialButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)
          ),
        ],
        elevation: 20.0,
      ),
    );
  }
  
  // save workout
  void save() {
    // get exercie name from text controller
    String newExerciseName = exerciseNameController.text;
    String tempo = tempoController.text;
    String chords = chordsController.text;
    String description = descriptionController.text;
    String playbackAudioFile = playbackAudioFileController.text;
    List<String> tags = [];
    // add exercise to workout
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName, 
        newExerciseName,
        tempo, 
        chords, 
        description, 
        playbackAudioFile, 
        tags,
      );

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
    exerciseNameController.clear();
    tempoController.clear();
    chordsController.clear();
    descriptionController.clear();
    playbackAudioFileController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.workoutName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF2e474c),
          elevation: 10,
          shadowColor: const Color(0xFF2e474c),
          actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFEB811B),
                ),
                onPressed: createNewExercise,
              ),
            ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getRandomExercise,
          child: const Icon(Icons.casino),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.numberOfExercises(widget.workoutName),
                itemBuilder: (context, index) => ExerciseTile(
                  exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                  tempo: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .tempo,
                  description: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .description, 
                  playbackAudioFile: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .playbackAudioFile, 
                  chords: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .chords, 
                  isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                    onCheckBoxChanged: (val) => onCheckBoxChanged(
                      widget.workoutName, 
                      value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name
                    ),
                  // tags: value.getRelevantWorkout(widget.workoutName).exercises[index].tags, 
                  // isCompleted: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted, 
                  // isFavorite: value.getRelevantWorkout(widget.workoutName).exercises[index].isFavorite
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}