import 'package:flutter/material.dart';
import 'package:neosapien_share/features/send/providers/send_upload_provider.dart';
import '../../../../core/theme/app_colors.dart';

class SendBottomActionBar extends StatelessWidget {
  const SendBottomActionBar({
    super.key,
    required this.state,
    required this.onCancel,
    required this.onRetry,
    required this.onDone,
  });

  final SendUploadState state;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: switch (state.phase) {
        SendPhase.uploading => _CancelButton(
          isCancelling: state.isCancelling,
          onCancel: onCancel,
        ),
        SendPhase.success => _DoneButton(onDone: onDone),
        SendPhase.partialFailure => _RetryActionBar(
          onRetry: onRetry,
          onDone: onDone,
        ),
        SendPhase.cancelled => _BackToHomeButton(onDone: onDone),
        SendPhase.idle => const SizedBox.shrink(),
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.isCancelling, required this.onCancel});
  final bool isCancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isCancelling ? AppColors.textMuted : AppColors.danger,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isCancelling ? null : onCancel,
        icon: isCancelling
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textMuted,
                ),
              )
            : const Icon(Icons.cancel_outlined, color: AppColors.danger),
        label: Text(
          isCancelling ? 'Cancelling…' : 'Cancel transfer',
          style: TextStyle(
            color: isCancelling ? AppColors.textMuted : AppColors.danger,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1A3A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onDone,
        icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
        label: const Text(
          'Done',
          style: TextStyle(
            color: AppColors.success,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _RetryActionBar extends StatelessWidget {
  const _RetryActionBar({required this.onRetry, required this.onDone});
  final VoidCallback onRetry;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.warning),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.warning),
              label: const Text(
                'Retry failed files',
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onDone,
            child: const Text(
              'Done',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackToHomeButton extends StatelessWidget {
  const _BackToHomeButton({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.divider,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onDone,
        child: const Text(
          'Back to home',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
