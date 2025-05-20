import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_service.dart';
import '../widgets/book_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _dbService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No favorite books yet.\nSearch and add some books to your favorites!',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookItem(
                  book: books[index],
                  isFavoriteScreen: true,
                  onFavoriteChanged: () {
                    // Refresh the list when a book is removed
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}