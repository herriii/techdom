import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/movie_model.dart';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();

  factory MovieDatabase() => _instance;

  Database? _database;

  MovieDatabase._internal();

  Future<Database> get database async {
    // Initialize the database if it's not already done
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDb();
      return _database!;
    }
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterURL TEXT,
            imdbId TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE Favourite (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterURL TEXT,
            imdbId TEXT
          )
        ''');
      },
    );
  }

  // Insert Movie
  Future<void> insertMovie(Movie movie) async {
    final db = await database;
    await db.insert('Movies', movie.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Favourite Movie
  Future<void> insertFavouriteMovie(Movie movie) async {
    final db = await database;
    await db.insert('Favourite', movie.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get All Movies
  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Movies');
    return List.generate(maps.length, (i) {
      return Movie.fromJson(maps[i]);
    });
  }

  // Get All Favourite Movies
  Future<List<Movie>> getAllFavouriteMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Favourite');
    return List.generate(maps.length, (i) {
      return Movie.fromJson(maps[i]);
    });
  }

  // Delete Movie
  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete('Movies', where: 'id = ?', whereArgs: [id]);
  }

  // Delete Favourite Movie
  Future<void> deleteFavouriteMovie(int id) async {
    final db = await database;
    await db.delete('Favourite', where: 'id = ?', whereArgs: [id]);
  }

  // Check if Movie Exists in Movies Table
  Future<bool> checkMovieExists(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('Movies', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  // Check if Movie Exists in Favourite Table
  Future<bool> checkFavouriteMovieExists(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('Favourite', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
