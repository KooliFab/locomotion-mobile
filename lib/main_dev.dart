import 'core/config/env.dart';
import 'main.dart' as app;

/// Dev entrypoint
void main() {
  AppConfig.setEnvironment(Environment.dev);
  app.main();
}
