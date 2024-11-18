class Movie {
  final int id;
  final String title;
  final String posterURL;
  final String imdbId;

  Movie({
    required this.id,
    required this.title,
    required this.posterURL,
    required this.imdbId,
  });

  // From JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterURL: json['posterURL'],
      imdbId: json['imdbId'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterURL': posterURL,
      'imdbId': imdbId,
    };
  }
}
