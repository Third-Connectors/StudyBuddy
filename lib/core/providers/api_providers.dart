import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_config.dart';
import '../network/api_client.dart';

/// Provider for the API client.
///
/// Usage:
/// ```dart
/// final apiClient = ref.read(apiClientProvider);
/// ```
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

/// Provider for updating the auth token.
///
/// Usage:
/// ```dart
/// ref.read(authTokenProvider.notifier).state = 'your-token';
/// ```
final authTokenProvider = StateNotifierProvider<AuthTokenNotifier, String?>((
  ref,
) {
  return AuthTokenNotifier(ref.watch(apiClientProvider));
});

class AuthTokenNotifier extends StateNotifier<String?> {
  final ApiClient _apiClient;

  AuthTokenNotifier(this._apiClient) : super(null);

  @override
  set state(String? newState) {
    super.state = newState;
    if (newState != null) {
      _apiClient.setAuthToken(newState);
    } else {
      _apiClient.clearAuthToken();
    }
  }
}
