import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_cubit.dart';
import 'package:dashboard/src/features/funds/presentation/state/funds_state.dart';

class MockFundsCubit extends MockCubit<FundsState> implements FundsCubit {}
