import 'package:dashboard/src/features/funds/domain/models/fund_model.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';
import 'package:dashboard/src/features/funds/presentation/widgets/cancel_dialog.dart';
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
  isSubscribed: true,
  subscribedAmount: 75000,
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
              body: CancelDialog(fund: _fund),
            ),
          ),
        ],
      ),
    ),
  );
}

void main() {
  late MockFundsCubit cubit;

  setUp(() {
    cubit = MockFundsCubit();
    when(() => cubit.state).thenReturn(const FundsState());
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  });

  group('CancelDialog', () {
    // ── render ────────────────────────────────────────────────────────────

    testWidgets('muestra el título "Cancelar participación"', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('Cancelar participación'), findsOneWidget);
    });

    testWidgets('muestra el nombre del fondo', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('DEUDAPRIVADA'), findsOneWidget);
    });

    testWidgets('muestra el monto a reintegrar en el aviso', (tester) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.textContaining('75.000'), findsWidgets);
    });

    testWidgets('muestra el botón "Confirmar" y "No cancelar"', (
      tester,
    ) async {
      await tester.pumpWidget(_build(cubit));
      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.text('No cancelar'), findsOneWidget);
    });

    // ── acciones ──────────────────────────────────────────────────────────

    testWidgets(
      '"Confirmar" llama cubit.cancel con el id del fondo',
      (tester) async {
        when(() => cubit.cancel(any())).thenAnswer((_) async {});
        await tester.pumpWidget(_build(cubit));
        await tester.tap(find.text('Confirmar'));
        verify(() => cubit.cancel('3')).called(1);
      },
    );

    // ── error inline ──────────────────────────────────────────────────────

    testWidgets(
      'muestra el banner de error cuando errorMessage no es null',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const FundsState(errorMessage: 'Fondo no encontrado'),
        );
        when(() => cubit.stream).thenAnswer(
          (_) => Stream.value(
            const FundsState(errorMessage: 'Fondo no encontrado'),
          ),
        );
        await tester.pumpWidget(_build(cubit));
        await tester.pump();
        expect(find.text('Fondo no encontrado'), findsOneWidget);
      },
    );

    testWidgets(
      'no muestra banner de error cuando errorMessage es null',
      (tester) async {
        await tester.pumpWidget(_build(cubit));
        expect(find.byIcon(Icons.error_outline), findsNothing);
      },
    );

    // ── estado isOperating ────────────────────────────────────────────────

    testWidgets(
      'botones deshabilitados cuando isOperating es true: '
      '"Confirmar" muestra spinner y no llama al cubit',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const FundsState(isOperating: true),
        );
        when(() => cubit.stream).thenAnswer(
          (_) => Stream.value(const FundsState(isOperating: true)),
        );
        await tester.pumpWidget(_build(cubit));
        await tester.pump();
        // isLoading:true reemplaza el texto del botón por un spinner
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        verifyNever(() => cubit.cancel(any()));
      },
    );
  });
}
