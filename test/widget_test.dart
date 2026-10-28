import 'package:flutter_test/flutter_test.dart';
import 'package:quanlychitieu/main.dart';

void main() {
  testWidgets('ExpenseTrackerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());
    expect(find.byType(ExpenseTrackerApp), findsOneWidget);
  });
}
