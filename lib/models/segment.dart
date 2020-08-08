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
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      segmentNumber: json['segment_number'] as int,
      realtimeDuration: Duration(milliseconds: json['realtime_duration_ms'] as int),
      gametimeDuration: Duration(milliseconds: json['gametime_duration_ms'] as int),
      realtimeStart: Duration(milliseconds: json['realtime_start_ms'] as int),
      gametimeStart: Duration(milliseconds: json['gametime_start_ms'] as int),
      realtimeEnd: Duration(milliseconds: json['realtime_end_ms'] as int),
      gametimeEnd: Duration(milliseconds: json['gametime_end_ms'] as int),
      realtimeShortestDuration: Duration(milliseconds: json['realtime_shortest_duration_ms'] as int),
      gametimeShortestDuration: Duration(milliseconds: json['gametime_shortest_duration_ms'] as int),
      realtimeGold: json['realtime_gold'] as bool,
      gametimeGold: json['gametime_gold'] as bool,
      realtimeSkipped: json['realtime_skipped'] as bool,
      gametimeSkipped: json['gametime_skipped'] as bool,
      realtimeReduced: json['realtime_reduced'] as bool,
      gametimeReduced: json['gametime_reduced'] as bool,
    );
  }
}
