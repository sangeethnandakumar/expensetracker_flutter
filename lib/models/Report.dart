class Track {
  final String id;
  final DateTime date;
  final double exp;
  final double inc;
  final String notes;

  Track({required this.id, required this.date, required this.exp, required this.inc, required this.notes});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      date: DateTime.parse(json['date']),
      exp: json['exp'].toDouble(),
      inc: json['inc'].toDouble(),
      notes: json['notes'],
    );
  }
}

class Breakdown {
  final String title;
  final String text;
  final double total;
  final List<Track> tracks;

  Breakdown({required this.title, required this.text, required this.total, required this.tracks});

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    var trackList = (json['tracks'] as List).map((track) => Track.fromJson(track)).toList();

    return Breakdown(
      title: json['title'],
      text: json['text'],
      total: json['total'].toDouble(),
      tracks: trackList,
    );
  }
}

class Report {
  final DateTime start;
  final DateTime end;
  final double total;
  final Map<String, Breakdown> breakdown;

  Report({required this.start, required this.end, required this.total, required this.breakdown});

  factory Report.fromJson(Map<String, dynamic> json) {
    var breakdownMap = (json['breakdown'] as Map<String, dynamic>).map((key, value) => MapEntry(key, Breakdown.fromJson(value)));

    return Report(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      total: json['total'].toDouble(),
      breakdown: breakdownMap,
    );
  }
}
