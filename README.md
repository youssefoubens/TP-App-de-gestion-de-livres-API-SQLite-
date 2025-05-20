# Book Manager App

## Description
The Book Manager App is a Flutter application that allows users to search for books using the Google Books API, save their favorite books locally using SQLite, and manage their list of favorites. Users can search for books by keywords, view details such as title, author, and cover image, and easily add or remove books from their favorites.

## Features
- Search for books using the Google Books API.
- Display search results with book details (title, author, image).
- Save favorite books locally in an SQLite database.
- View and manage a list of favorite books.
- Remove books from favorites with a simple action.

## Project Structure
```
book_manager_app
├── lib
│   ├── main.dart               # Entry point of the application
│   ├── models
│   │   └── book.dart           # Book model definition
│   ├── services
│   │   └── db_service.dart     # Database service for managing favorites
│   ├── pages
│   │   ├── home_page.dart      # Home page for searching books
│   │   └── favorites_page.dart  # Page for displaying favorite books
│   └── widgets
│       └── book_item.dart      # Widget for displaying a single book
├── pubspec.yaml                # Project configuration and dependencies
└── README.md                   # Project documentation
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   cd book_manager_app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run
   ```

## Usage
- On the Home Page, enter a keyword in the search bar to find books.
- Browse the search results and click the favorite button to save a book.
- Navigate to the Favorites Page to view and manage your saved books.
- Remove a book from favorites by clicking the delete button.

## API Reference
This application uses the Google Books API for searching books. Example API call:
```
https://www.googleapis.com/books/v1/volumes?q={keyword}
```

## License
This project is open-source and available under the MIT License.