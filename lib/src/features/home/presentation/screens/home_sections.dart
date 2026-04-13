import 'package:dashboard/src/config/inyection/global_locator.dart';
import 'package:dashboard/src/core/api/api_client.dart';
import 'package:dashboard/src/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:dashboard/src/features/home/domain/repositories/dashboard_repository.dart';
import 'package:dashboard/src/features/home/presentation/widgets/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DashboardRepository>(
      create: (_) => DashboardRepositoryImpl(apiClient: global<ApiClient>()),
      child: const DashboardView(),
    );
  }
}
