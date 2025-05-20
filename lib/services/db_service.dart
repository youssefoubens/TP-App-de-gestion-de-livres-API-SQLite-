// db_service.dart
import '../models/book.dart';
import 'storage_service_factory.dart';
import 'storage_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  final StorageService _storageService =
      StorageServiceFactory.getStorageService();

  // Insert a book into favorites
  Future<void> insertItem(Book book) async {
    await _storageService.saveBook(book);
  }

  // Get all favorite books
  Future<List<Book>> getItems() async {
    return await _storageService.getAllBooks();
  }

  // Check if a book is a favorite
  Future<bool> isItemFavorite(String id) async {
    return await _storageService.isBookSaved(id);
  }

  // Delete a book from favorites
  Future<void> deleteItem(String id) async {
    await _storageService.deleteBook(id);
  }
}
