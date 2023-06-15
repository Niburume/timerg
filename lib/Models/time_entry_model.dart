class TimeEntry {
  String? id;
  final String duration;
  final String userId;
  final String projectId;
  String? note;
  String? tag;
  final DateTime? timeFrom;
  final DateTime? timeTo;
  final bool autoAdding;

  TimeEntry(
      {this.id,
      required this.userId,
      required this.duration,
      required this.projectId,
      this.note,
      this.tag,
      this.timeFrom,
      this.timeTo,
      required this.autoAdding});

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
        id: json['id'] as String,
        userId: json['userId'] as String,
        duration: json['duration'] as String,
        projectId: json['projectId'] as String,
        note: json['note'] as String?,
        tag: json['tag'] as String?,
        timeFrom: DateTime.parse(json['timeFrom']) as DateTime?,
        timeTo: DateTime.parse(json['timeFrom']) as DateTime?,
        autoAdding: json['autoCheckIn'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'duration': duration.toString(),
      'projectId': projectId,
      'note': note,
      'tag': tag,
      'timeFrom': timeFrom?.toIso8601String(),
      'timeTo': timeTo?.toIso8601String(),
      'autoCheckIn': autoAdding
    };
  }

  Duration durationFromString(String duration) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = duration.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
