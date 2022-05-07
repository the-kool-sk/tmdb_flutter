import 'Result.dart';

class Movie {
  int? page;
  List<Result>? results;
  int? total_pages;
  int? total_results;

  Movie({this.page, this.results, this.total_pages, this.total_results});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      page: json['page'],
      results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null,
      total_pages: json['total_pages'],
      total_results: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_pages'] = this.total_pages;
    data['total_results'] = this.total_results;
    if (this.results != null) {
      data['results'] = this.results?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
