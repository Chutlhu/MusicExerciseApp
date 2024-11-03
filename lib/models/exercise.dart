class Exercise {
  
  final String name;
  final String tempo;
  final String chords;
  final String description;
  final String playbackAudioFile;
  
  List<String> tags = [];
  bool isCompleted = false;
  bool isFavorite = false;

  Exercise({
    required this.name, 
    required this.tempo, 
    required this.chords, 
    required this.description, 
    required this.playbackAudioFile,
    this.tags = const [],
    this.isCompleted = false,
    this.isFavorite = false,
  });
}