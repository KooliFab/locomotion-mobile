import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'secure_storage.dart';

part 'storage_providers.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
}
