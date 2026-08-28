import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

/// Reusable profile presentation card.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    this.onEdit,
  });

  final UserProfile profile;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            AppSpacing.gapV16,
            Text(
              profile.name,
              style: theme.textTheme.titleLarge,
            ),
            AppSpacing.gapV4,
            Text(
              profile.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            AppSpacing.gapV8,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                profile.role,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (profile.bio != null) ...[
              AppSpacing.gapV16,
              Text(
                profile.bio!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onEdit != null) ...[
              AppSpacing.gapV24,
              AppButton(
                text: 'Edit Profile',
                variant: AppButtonVariant.outlined,
                onPressed: onEdit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
