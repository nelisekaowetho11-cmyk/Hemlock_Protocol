
import 'package:flutter_test/flutter_test.dart';
import 'package:primenet_vpn/main.dart';

void main() {
  testWidgets('PrimeNet VPN app starts', (tester) async {
    await tester.pumpWidget(const PrimeNetApp());

    expect(find.textContaining('PrimeNet VPN'), findsOneWidget);
  });
}
