import 'package:equatable/equatable.dart';

import 'Genre.dart';

class Genres implements Equatable{
  List<Genre>? genres;

  Genres({this.genres});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      genres: json['genres'] != null ? (json['genres'] as List).map((i) => Genre.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (genres != null) {
      data['genres'] = genres?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [genres];

  @override
  bool? get stringify => true;
}
