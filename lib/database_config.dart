import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initializeDatabase() {
  // Initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize sqflite_ffi
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
    print('Initialized SQLite for desktop with FFI');
  } else {
    // For Android/iOS, the default factory works fine
    print('Using default SQLite implementation for mobile');
  }
}