// storage_service_factory.dart
import 'package:book_manager_app/services/native_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'storage_service.dart';
import 'web_storage_service.dart'
    if (dart.library.io) 'native_storage_service.dart';

class StorageServiceFactory {
  static StorageService getStorageService() {
    if (kIsWeb) {
      return WebStorageService();
    } else {
      return NativeStorageService();
    }
  }
}
