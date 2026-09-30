import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/env.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loanable_image.dart';

/// Loads `GET /images/{id}` (raw bytes, auth required) with the stored
/// access token. Falls back to a sober placeholder when there is no image
/// or the request fails.
class LoanableImageWidget extends ConsumerStatefulWidget {
  final LoanableImage? image;
  final double height;
  final double width;

  const LoanableImageWidget({
    super.key,
    required this.image,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  ConsumerState<LoanableImageWidget> createState() =>
      _LoanableImageWidgetState();
}

class _LoanableImageWidgetState extends ConsumerState<LoanableImageWidget> {
  Future<String?>? _tokenFuture;

  @override
  void initState() {
    super.initState();
    _resolveToken();
  }

  void _resolveToken() {
    final storage = ref.read(secureStorageServiceProvider);
    _tokenFuture = storage.getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image == null) {
      return _placeholder(widget.height, widget.width);
    }

    final baseUrl = ref.watch(apiBaseUrlProvider);
    final url = widget.image!.buildUrl(baseUrl);

    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: widget.height,
            width: widget.width,
            color: AppColors.lightTint,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
          );
        }

        final token = snapshot.data;
        return Image.network(
          url,
          height: widget.height,
          width: widget.width,
          fit: BoxFit.cover,
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
            'Accept': 'image/*',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: widget.height,
              width: widget.width,
              color: AppColors.lightTint,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              _placeholder(widget.height, widget.width),
        );
      },
    );
  }

  Widget _placeholder(double h, double w) {
    return Container(
      height: h,
      width: w,
      color: AppColors.lightTint,
      alignment: Alignment.center,
      child: const Icon(
        Icons.directions_car_rounded,
        size: 56,
        color: AppColors.primaryDark,
      ),
    );
  }
}
