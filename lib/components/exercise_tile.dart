import 'package:flutter/material.dart';


class ExerciseTile extends StatelessWidget {

  final String exerciseName;
  final String tempo;
  final String chords;
  final String description;
  final String playbackAudioFile;
  // final List<String> tags;

  final bool isCompleted;
  // final bool isFavorite;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.tempo,
    required this.chords,
    required this.description,
    required this.playbackAudioFile, // --> backingTrack or playAlongTrack
    // required this.tags,
    required this.isCompleted,
    // required this.isFavorite,
    required this.onCheckBoxChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(
          children: [
            Chip(
              label: Text("${tempo} bpm"),
            ),
            Chip(
              label: Text(chords),
            ),
            Chip(
              label: Text(playbackAudioFile),
            ),      
            Chip(
              label: Text(description),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted, 
          onChanged: (value) => onCheckBoxChanged!(value)),
      ),
    );
  }

}