import 'package:bass_workout_app/data/hive_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../models/workouts.dart';
import '../models/exercise.dart';

class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();

  List<Workout> workoutsList = [
    // default workout
    Workout(
      name: 'Harmony',
      exercises: [
        Exercise(
          name: 'C Major Scale',
          tempo: '110',
          chords: 'Circle of 4ths',
          description: 'Play the C Major Scale',
          playbackAudioFile: 'c_major_scale.mp3',
          tags: ['Scale', 'Major', 'C', '2-bars']
        ),
      ]
    ),
    Workout(
      name: 'Etude',
      exercises: [
        Exercise(
          name: 'Arpeggio 1',
          tempo: '95',
          chords: 'G maj',
          description: 'Bach the river',
          playbackAudioFile: 'c_major_scale.mp3',
          tags: ['Scale', 'Major', 'C', '2-bars']
        ),
      ]
    ),
  ];

  // if there are workouts in the database, then get that workout list
  void initializeWorkoutsList() {
    if (db.previousDataExists()) {
      workoutsList = db.readFromDatabase();
    }
    // otherwise, save the default workout list to the database
    else {
      print("No previous data exists");
      db.saveToDatabase(workoutsList);
    }
  }

  // Get the list of workouts
  List<Workout> getWorkoutsList() {
    return workoutsList;
  }

  // Add a new workout
  void addWorkout(String name) {
    workoutsList.add(Workout(name: name, exercises: []));

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutsList);
  }

  // Add an exercise to a workout
  void addExercise(
    String workoutName, 
    String exerciseName, 
    String tempo,
    String chords,
    String description,
    String playbackAudioFile,
    List<String> tags
    ) {
      // find the relevant workout
      Workout relevantWorkout = 
        workoutsList.firstWhere((workout) => workout.name == workoutName);
      
      relevantWorkout.exercises.add(
        Exercise(
          name: exerciseName,
          tempo: tempo,
          chords: chords,
          description: description,
          playbackAudioFile: playbackAudioFile,
          tags: tags
        )
      );
    
    notifyListeners();
    // save to database
    db.saveToDatabase(workoutsList);
  }

  // return the relevant workout
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = 
      workoutsList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  // return the relevant exercise
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise = 
      relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  Exercise getRandomExercise(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // get a random index from 0 to the length of the exercises list
    int index = Random().nextInt(relevantWorkout.exercises.length);
    return relevantWorkout.exercises[index];
  }

  // check off exercise
  void checkoffExercise(String workoutName, String exerciseName) {
    // find the relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    
    // toggle the isCompleted property
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutsList);
  }

  // get number of given workout
  int numberOfExercises(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }
  
}
