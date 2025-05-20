import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  
  // Singleton pattern for API service
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() => _instance;
  
  ApiService._internal();
  
  /// Searches for books using the Google Books API
  /// 
  /// [query] is the search term to look for
  /// Returns a Future with a list of Book objects or throws an exception
  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    
    // Encode the query parameter for URL
    final encodedQuery = Uri.encodeComponent(query.trim());
    final url = '$_baseUrl?q=$encodedQuery';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>?;
        
        if (items == null || items.isEmpty) {
          return [];
        }
        
        // Convert each item to a Book object
        return items.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load books: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }
  
  /// Fetches details for a specific book by its ID
  /// 
  /// [bookId] is the Google Books volume ID
  /// Returns a Future with a Book object or throws an exception
  Future<Book> getBookDetails(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw Exception('Book ID cannot be empty');
    }
    
    final url = '$_baseUrl/$bookId';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        throw Exception('Failed to load book details: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }
}