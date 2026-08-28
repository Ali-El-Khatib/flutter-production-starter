import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/profile/presentation/state/profile_bloc.dart';
import 'package:mobile/features/profile/presentation/widgets/profile_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// User profile presentation page.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.profileBloc,
    required this.messageResolver,
    this.onBack,
  });

  final ProfileBloc profileBloc;
  final FailureMessageResolver messageResolver;
  final VoidCallback? onBack;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.profileBloc.loadProfile();
  }

  void _showEditDialog(BuildContext context) {
    final currentProfile = widget.profileBloc.state.value.profile;
    final nameController =
        TextEditingController(text: currentProfile?.name ?? '');
    final bioController =
        TextEditingController(text: currentProfile?.bio ?? '');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                label: 'Full Name',
                hintText: 'Enter your name',
              ),
              AppSpacing.gapV16,
              AppTextField(
                controller: bioController,
                label: 'Bio',
                hintText: 'Enter a short bio',
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.profileBloc.updateProfile(
                  name: nameController.text,
                  bio: bioController.text,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: widget.onBack,
              )
            : null,
      ),
      body: SignalBuilder(
        builder: (context) {
          final state = widget.profileBloc.state();

          if (state.isLoading) {
            return const AppLoader(message: 'Loading profile...');
          }

          if (state.failure != null && state.profile == null) {
            return AppErrorView(
              message: widget.messageResolver.resolve(state.failure!),
              onRetry: () => widget.profileBloc.loadProfile(),
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return SingleChildScrollView(
            padding: AppSpacing.paddingMd,
            child: Column(
              children: [
                ProfileCard(
                  profile: profile,
                  onEdit: () => _showEditDialog(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
