import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:live_stream/model/Movie.dart';
import 'package:live_stream/model/geners.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          title: 'Movies DB',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MoviesListWidget());
    });
  }
}

class MoviesListWidget extends StatefulWidget {
  const MoviesListWidget({Key? key}) : super(key: key);

  @override
  State<MoviesListWidget> createState() => _MoviesListWidgetState();
}

class _MoviesListWidgetState extends State<MoviesListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(Uri.parse("https://api.themoviedb.org/3/genre/movie/list?api_key=02544ea8d329761b574e6ae2f53bab7d&language=en-US")),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          Genres genres = Genres.fromJson(jsonDecode(snapshot.data?.body ?? "{}"));
          return SizerUtil.deviceType == DeviceType.mobile ? MobileView(genres) : DesktopView(genres);
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error has occurred"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MobileView extends StatefulWidget {
  Genres genres;

  MobileView(this.genres, {Key? key}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return SizedBox(
              height: 20.w,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(widget.genres.genres?[index].name ?? ""),
                    ),
                  ),
                  FutureBuilder(
                    future: http.get(Uri.parse(
                        "https://api.themoviedb.org/3/discover/movie?with_genres=${widget.genres.genres?[index].id ?? 0}&api_key=02544ea8d329761b574e6ae2f53bab7d")),
                    builder: (context, AsyncSnapshot<Response> snapshot) {
                      if (snapshot.hasData) {
                        Movie movie = Movie.fromJson(jsonDecode(snapshot.data?.body ?? "{}"));
                        return Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                                width: 50,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.black),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w200/${movie.results?[index].poster_path}",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: movie.results?.length ?? 0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, count) {
            return const Divider(
              thickness: 2.0,
            );
          },
          itemCount: widget.genres.genres?.length ?? 0,
        ),
      ),
    );
  }
}

class DesktopView extends StatefulWidget {
  Genres genres;

  DesktopView(this.genres, {Key? key}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return SizedBox(
              height: 15.h,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(widget.genres.genres?[index].name ?? ""),
                    ),
                  ),
                  FutureBuilder(
                    future: http.get(Uri.parse(
                        "https://api.themoviedb.org/3/discover/movie?with_genres=${widget.genres.genres?[index].id ?? 0}&api_key=02544ea8d329761b574e6ae2f53bab7d")),
                    builder: (context, AsyncSnapshot<Response> snapshot) {
                      if (snapshot.hasData) {
                        Movie movie = Movie.fromJson(jsonDecode(snapshot.data?.body ?? "{}"));
                        return Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 10.h,
                                width: 10.h,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.black),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w200/${movie.results?[index].poster_path}",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: movie.results?.length ?? 0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, count) {
            return const Divider(
              thickness: 2.0,
            );
          },
          itemCount: widget.genres.genres?.length ?? 0,
        ),
      ),
    );
  }
}
