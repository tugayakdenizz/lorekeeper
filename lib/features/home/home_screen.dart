import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/new_releases_section.dart';
import 'widgets/stats_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(),
              SizedBox(height: AppSpacing.xl),
              ContinueReadingCard(),
              SizedBox(height: AppSpacing.xl),
              NewReleasesSection(),
              SizedBox(height: AppSpacing.xl),
              StatsGrid(),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}