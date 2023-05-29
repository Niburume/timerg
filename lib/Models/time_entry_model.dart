class TimeEntry {
  final double duration;
  final String userId;
  String projectId;
  String? note;
  String? tag;
  DateTime? timeFrom;
  DateTime? timeTo;

  TimeEntry(
      {required this.userId,
      required this.duration,
      required this.projectId,
      this.note,
      this.tag,
      this.timeFrom,
      this.timeTo});
}
