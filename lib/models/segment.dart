class Segment {
  final String id;
  final String name;
  final String displayName;
  final int segmentNumber;
  final Duration realtimeDuration;
  final Duration gametimeDuration;
  final Duration realtimeStart;
  final Duration gametimeStart;
  final Duration realtimeEnd;
  final Duration gametimeEnd;
  final Duration realtimeShortestDuration;
  final Duration gametimeShortestDuration;
  final bool realtimeGold;
  final bool gametimeGold;
  final bool realtimeSkipped;
  final bool gametimeSkipped;
  final bool realtimeReduced;
  final bool gametimeReduced;

  Segment({
    this.id,
    this.name,
    this.displayName,
    this.segmentNumber,
    this.realtimeDuration,
    this.gametimeDuration,
    this.realtimeStart,
    this.gametimeStart,
    this.realtimeEnd,
    this.gametimeEnd,
    this.realtimeShortestDuration,
    this.gametimeShortestDuration,
    this.realtimeGold,
    this.gametimeGold,
    this.realtimeSkipped,
    this.gametimeSkipped,
    this.realtimeReduced,
    this.gametimeReduced,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      segmentNumber: json['segment_number'],
      realtimeDuration: Duration(milliseconds: json['realtime_duration_ms']),
      gametimeDuration: Duration(milliseconds: json['gametime_duration_ms']),
      realtimeStart: Duration(milliseconds: json['realtime_start_ms']),
      gametimeStart: Duration(milliseconds: json['gametime_start_ms']),
      realtimeEnd: Duration(milliseconds: json['realtime_end_ms']),
      gametimeEnd: Duration(milliseconds: json['gametime_end_ms']),
      realtimeShortestDuration: Duration(milliseconds: json['realtime_shortest_duration_ms']),
      gametimeShortestDuration: Duration(milliseconds: json['gametime_shortest_duration_ms']),
      realtimeGold: json['realtime_gold'],
      gametimeGold: json['gametime_gold'],
      realtimeSkipped: json['realtime_skipped'],
      gametimeSkipped: json['gametime_skipped'],
      realtimeReduced: json['realtime_reduced'],
      gametimeReduced: json['gametime_reduced'],
    );
  }
}
