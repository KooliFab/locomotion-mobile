import 'core/config/env.dart';
import 'main.dart' as app;

/// Staging entrypoint
void main() {
  AppConfig.setEnvironment(Environment.staging);
  app.main();
}
