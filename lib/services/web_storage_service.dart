// web_storage_service.dart
import 'dart:convert';
import 'dart:html' as html;
import '../models/book.dart';
import 'storage_service.dart';

class WebStorageService implements StorageService {
  static const String _storageKey = 'favorite_books';
  
  @override
  Future<void> saveBook(Book book) async {
    final books = await getAllBooks();
    
    // Check if book already exists, if so, replace it
    final existingIndex = books.indexWhere((b) => b.id == book.id);
    if (existingIndex >= 0) {
      books[existingIndex] = book;
    } else {
      books.add(book);
    }
    
    _saveToLocalStorage(books);
  }
  
  @override
  Future<List<Book>> getAllBooks() async {
    final data = html.window.localStorage[_storageKey];
    if (data == null || data.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => Book.fromMap(Map<String, dynamic>.from(item))).toList();
    } catch (e) {
      print('Error parsing localStorage data: $e');
      return [];
    }
  }
  
  @override
  Future<bool> isBookSaved(String id) async {
    final books = await getAllBooks();
    return books.any((book) => book.id == id);
  }
  
  @override
  Future<void> deleteBook(String id) async {
    final books = await getAllBooks();
    books.removeWhere((book) => book.id == id);
    _saveToLocalStorage(books);
  }
  
  void _saveToLocalStorage(List<Book> books) {
    final jsonList = books.map((book) => book.toMap()).toList();
    html.window.localStorage[_storageKey] = json.encode(jsonList);
  }
}