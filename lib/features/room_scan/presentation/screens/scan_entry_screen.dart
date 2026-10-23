import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../providers/scan_providers.dart';
import 'room_scan_screen.dart';
import 'spatial_scan_screen.dart';

/// Elige con qué se mide la habitación nueva, según lo que tenga el
/// teléfono.
///
/// Aquí solo se entra desde «Nueva habitación», así que lo único que se
/// ofrece es levantar su plano. La altura del techo se mide desde la
/// habitación, que es donde vive.
class ScanEntryScreen extends ConsumerWidget {
  const ScanEntryScreen({required this.projectId, super.key});

  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> arCore = ref.watch(arCoreProvider);

    return arCore.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.darkNavy,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, StackTrace _) =>
          RoomScanScreen(projectId: projectId),
      data: (bool available) => available
          ? SpatialScanScreen(projectId: projectId)
          : RoomScanScreen(projectId: projectId),
    );
  }
}
