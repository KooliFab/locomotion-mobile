import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final VoidCallback? onRetry;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () =>
          loading?.call() ??
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
      error: (e, st) {
        if (error != null) {
          return error!(e, st);
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.danger,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Réessayer',
                    variant: AppButtonVariant.outline,
                    onPressed: onRetry,
                    height: 40,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
