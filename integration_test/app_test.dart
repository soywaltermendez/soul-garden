import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:soul-garden/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete mindfulness exercise flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la pantalla de mindfulness
      await tester.tap(find.byIcon(Icons.self_improvement));
      await tester.pumpAndSettle();

      // Seleccionar un ejercicio
      await tester.tap(find.text('Respiración consciente').first);
      await tester.pumpAndSettle();

      // Completar el ejercicio
      await tester.tap(find.text('Comenzar'));
      await tester.pumpAndSettle();

      // Esperar la duración del ejercicio
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Verificar que se muestra la pantalla de completado
      expect(find.text('¡Ejercicio completado!'), findsOneWidget);
    });

    testWidgets('premium features are locked for free users', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la pantalla de mindfulness
      await tester.tap(find.byIcon(Icons.self_improvement));
      await tester.pumpAndSettle();

      // Intentar acceder a un ejercicio premium
      await tester.tap(find.text('Meditación guiada').first);
      await tester.pumpAndSettle();

      // Verificar que se muestra el diálogo de premium
      expect(find.text('Ejercicio Premium'), findsOneWidget);
    });
  });
} 