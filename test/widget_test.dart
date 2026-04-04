import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopbansach/presentation/bloc/app.dart';
import 'package:shopbansach/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
  });

  testWidgets('App load test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await di.init();
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}