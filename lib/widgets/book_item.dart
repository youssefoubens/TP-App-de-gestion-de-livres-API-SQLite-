import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_service.dart';
import '../pages/detail_page.dart';

class BookItem extends StatefulWidget {
  final Book book;
  final bool isFavoriteScreen;
  final VoidCallback? onFavoriteChanged;

  const BookItem({
    Key? key,
    required this.book,
    this.isFavoriteScreen = false,
    this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  final DatabaseService _dbService = DatabaseService();
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    if (widget.isFavoriteScreen) {
      setState(() {
        _isFavorite = true;
        _isLoading = false;
      });
    } else {
      final result = await _dbService.isItemFavorite(widget.book.id);
      setState(() {
        _isFavorite = result;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    if (_isFavorite) {
      await _dbService.deleteItem(widget.book.id);
    } else {
      await _dbService.insertItem(widget.book);
    }

    setState(() {
      _isFavorite = !_isFavorite;
      _isLoading = false;
    });

    if (widget.onFavoriteChanged != null) {
      widget.onFavoriteChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(book: widget.book),
          ),
        ).then((_) {
          // Refresh when returning from detail page
          if (widget.onFavoriteChanged != null) {
            widget.onFavoriteChanged!();
          }
          _checkIfFavorite();
        });
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.book.imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.author,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Favorite button
              IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null,
                      ),
                onPressed: _isLoading ? null : _toggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}