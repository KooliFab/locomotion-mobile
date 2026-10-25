import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Signals that the network layer ended the session on its own: the refresh
/// token was rejected, or a retried request was still unauthorized.
///
/// The tokens are already gone when this fires. Listeners (the auth
/// controller) only have to bring the UI back to a signed-out state.
class SessionExpiryNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void signal() => state++;
}

final sessionExpiryProvider = NotifierProvider<SessionExpiryNotifier, int>(
  SessionExpiryNotifier.new,
);
