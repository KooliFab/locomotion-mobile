import 'core/config/env.dart';
import 'main.dart' as app;

/// Production entrypoint
void main() {
  AppConfig.setEnvironment(Environment.prod);
  app.main();
}
