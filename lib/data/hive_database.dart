import 'package:bass_workout_app/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/exercise.dart';
import '../models/workouts.dart';

class HiveDatabase {

  // reference our hive box
  final _myBox = Hive.box('workouts_db2');

  // check if there is already data stored, if not, record the start data
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('Previous data does not exist');
      _myBox.put('START_DATE', todayDateYYYYMMDD());
      return false;
    } else {
      print('Previous data does exist');
      return true;
    }
  }

  // return start date
  String getStartDate() {
    return _myBox.get('START_DATE');
  }

  // write data to the database
  void saveToDatabase(List<Workout> workouts) {
    // convert the workouts into a list of strings
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerxiseList(workouts);
    
    if (exerciseCompleted(workouts)) {
      _myBox.put('COMPLETION_STATUS_${todayDateYYYYMMDD()}', 1);
    } else {
      _myBox.put('COMPLETION_STATUS_${todayDateYYYYMMDD()}', 0);

    }

    // save into hive
    _myBox.put('WORKOUTS', workoutList);
    _myBox.put('EXERCISES', exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {

    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get('WORKOUTS');
    final exerciseDatails = _myBox.get('EXERCISES');

    // create workout objectes
    for (int i=0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exercisesInEachWortout = [];

      for (int j=0; j<exerciseDatails[i].length; j++) {
        // so add each exercise to the list
        exercisesInEachWortout.add(
          Exercise(
            name: exerciseDatails[i][j][0],
            tempo: exerciseDatails[i][j][1],
            chords: exerciseDatails[i][j][2],
            description: exerciseDatails[i][j][3],
            playbackAudioFile: exerciseDatails[i][j][4],
            isCompleted: exerciseDatails[i][j][5] == 'true' ? true : false,
          )
        );
      }

      // create individual workout
      Workout workout =
        Workout(name: workoutNames[i], exercises: exercisesInEachWortout);

      // add individual workout to the list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return the completion status
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get('COMPLETION_STATUS_$yyyymmdd') ?? 0;
    return completionStatus;
  }

}

// convert workout data into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    // e.g. cmajor, dmajor, emajor
  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}


// convert the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerxiseList(List<Workout> workouts) {
  
    List<List<List<String>>> exerciseList = [
      // [ [100bpm, circle_of_fifths], [120bpm, circle_of_fifths] ]
    ];
  
    for (int i = 0; i < workouts.length; i++) {
      
      List<Exercise> exercisesInWorkout = workouts[i].exercises;
      List<List<String>> individualWorkout = [];

      for (int j = 0; j < exercisesInWorkout.length; j++) {

        List<String> individualExercise = [];

        individualExercise.addAll(
          [
            exercisesInWorkout[j].name,
            exercisesInWorkout[j].tempo,
            exercisesInWorkout[j].chords,
            exercisesInWorkout[j].description,
            exercisesInWorkout[j].playbackAudioFile,
            exercisesInWorkout[j].isCompleted.toString(),
          ]
        );
        print(individualExercise);
        individualWorkout.add(individualExercise);
      }
      
      exerciseList.add(individualWorkout);
    }
    
    return exerciseList;
}