class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Handle potential null values and nested structures from Google Books API
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    // For authors, check if it exists and join them if there are multiple
    List<dynamic> authorsList = volumeInfo['authors'] ?? [];
    String authorText = authorsList.isNotEmpty ? authorsList.join(', ') : 'Unknown Author';
    
    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author: authorText,
      imageUrl: imageLinks['thumbnail'] ?? 'https://via.placeholder.com/128x192?text=No+Image',
    );
  }

  // Convert book to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
    };
  }

  // Create a Book from SQLite data
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      imageUrl: map['imageUrl'],
    );
  }
}