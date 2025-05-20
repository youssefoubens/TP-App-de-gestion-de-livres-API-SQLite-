// storage_service.dart
import '../models/book.dart';

abstract class StorageService {
  Future<void> saveBook(Book book);
  Future<List<Book>> getAllBooks();
  Future<bool> isBookSaved(String id);
  Future<void> deleteBook(String id);
}
