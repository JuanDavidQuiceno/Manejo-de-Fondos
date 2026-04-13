import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/domain/models/transaction_model.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/subscribe_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_funds_cubit.dart';

final _fund = FundModel(
  id: '3',
  name: 'DEUDAPRIVADA',
  minAmount: 50000,
  category: 'FIC',
);

Widget _build(FundsCubit cubit) {
  return BlocProvider<FundsCubit>.value(
    value: cubit,
    child: MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(
              body: SingleChildScrollView(
                child: SubscribeDialog(fund: _fund),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void main() {
  late MockFundsCubit cubit;

  setUpAll(() {
    registerFallbackValue(NotificationMethod.email);
  });

  setUp(() {
    cubit = MockFundsCubit();
    when(() => cubit.state).thenReturn(const FundsState());
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  });

  group('SubscribeDialog', () {
    // ── render ────────────────────────────────────────────────────────────

    testWidgets('muestra el título "Suscribirse al fondo"', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('Suscribirse al fondo'), findsOneWidget);
    });

    testWidgets('muestra el nombre del fondo', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('DEUDAPRIVADA'), findsOneWidget);
    });

    testWidgets(
      'muestra el monto mínimo del fondo',
      (tester) async {
        await tester.pumpWidget(_build(cubit));
        expect(find.textContaining('50.000'), findsWidgets);
      },
    );

    testWidgets('el campo de monto tiene el mínimo como valor inicial', (
      tester,
    ) async {
      await tester.pumpWidget(_build(cubit));
      final field = tester.widget<EditableText>(
        find.byType(EditableText).first,
      );
      expect(field.controller.text, '50000');
    });

    testWidgets('muestra el botón "Confirmar suscripción"', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('Confirmar suscripción'), findsOneWidget);
    });

    // ── validación de formulario ──────────────────────────────────────────

    testWidgets(
      'monto menor al mínimo muestra error de validación '
      'y no llama al cubit',
      (tester) async {
        await tester.pumpWidget(_build(cubit));
        await tester.enterText(find.byType(TextFormField), '1000');
        await tester.tap(find.text('Confirmar suscripción'));
        await tester.pump();
        expect(find.textContaining('Mínimo'), findsOneWidget);
        verifyNever(
          () => cubit.subscribe(
            fundId: any(named: 'fundId'),
            amount: any(named: 'amount'),
            notificationMethod: any(named: 'notificationMethod'),
          ),
        );
      },
    );

    testWidgets(
      'monto válido llama cubit.subscribe con los valores del form',
      (tester) async {
        when(
          () => cubit.subscribe(
            fundId: any(named: 'fundId'),
            amount: any(named: 'amount'),
            notificationMethod: any(named: 'notificationMethod'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(_build(cubit));
        await tester.enterText(find.byType(TextFormField), '60000');
        await tester.tap(find.text('Confirmar suscripción'));
        await tester.pump();

        verify(
          () => cubit.subscribe(
            fundId: '3',
            amount: 60000,
            notificationMethod: any(named: 'notificationMethod'),
          ),
        ).called(1);
      },
    );

    // ── error inline ──────────────────────────────────────────────────────

    testWidgets(
      'muestra el banner de error cuando errorMessage no es null',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const FundsState(errorMessage: 'Saldo insuficiente'),
        );
        when(() => cubit.stream).thenAnswer(
          (_) => Stream.value(
            const FundsState(errorMessage: 'Saldo insuficiente'),
          ),
        );
        await tester.pumpWidget(_build(cubit));
        await tester.pump();
        expect(find.text('Saldo insuficiente'), findsOneWidget);
      },
    );

    testWidgets(
      'no muestra banner cuando errorMessage es null',
      (tester) async {
        await tester.pumpWidget(_build(cubit));
        expect(find.byIcon(Icons.error_outline), findsNothing);
      },
    );
  });
}
