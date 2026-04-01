import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopbansach/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(sharedPreferences: sharedPreferences));

    // Verify if the app starts (usually shows SplashScreen or AuthScreen)
    expect(find.byType(MyApp), findsOneWidget);
  });
}
