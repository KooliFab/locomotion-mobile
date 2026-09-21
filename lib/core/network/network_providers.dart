import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/env.dart';
import '../storage/storage_providers.dart';
import 'api_client.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiClient.create(storageService: storageService, baseUrl: baseUrl);
}
