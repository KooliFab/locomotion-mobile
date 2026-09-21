import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/community.dart';
import '../controllers/communities_controller.dart';

class CommunitiesScreen extends ConsumerWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(communitiesListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communautés'),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(communitiesListControllerProvider.notifier).refresh(),
        child: AsyncValueWidget<List<Community>>(
          value: communitiesAsync,
          onRetry: () => ref.read(communitiesListControllerProvider.notifier).refresh(),
          data: (communities) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: communities.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final community = communities[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.lightTint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: AppColors.primaryDark,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    community.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (community.city != null)
                                    Text(
                                      community.city!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (community.description != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            community.description!,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (community.membersCount != null) ...[
                              const Icon(Icons.person_outline, size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                '${community.membersCount} membres',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 16),
                            ],
                            if (community.loanablesCount != null) ...[
                              const Icon(Icons.directions_car_outlined, size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                '${community.loanablesCount} véhicules/vélos',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
