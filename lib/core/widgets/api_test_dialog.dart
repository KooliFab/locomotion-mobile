import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/network_providers.dart';
import '../theme/app_colors.dart';

class ApiTestDialog extends ConsumerStatefulWidget {
  const ApiTestDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ApiTestDialog(),
    );
  }

  @override
  ConsumerState<ApiTestDialog> createState() => _ApiTestDialogState();
}

class _ApiTestDialogState extends ConsumerState<ApiTestDialog> {
  bool _isLoading = false;
  int? _statusCode;
  int? _durationMs;
  String? _endpointTested;
  dynamic _responseData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _runTest('/communities');
  }

  Future<void> _runTest(String endpoint) async {
    setState(() {
      _isLoading = true;
      _endpointTested = endpoint;
      _errorMessage = null;
      _responseData = null;
      _statusCode = null;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get<dynamic>(endpoint);
      stopwatch.stop();

      setState(() {
        _isLoading = false;
        _statusCode = response.statusCode;
        _durationMs = stopwatch.elapsedMilliseconds;
        _responseData = response.data;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _isLoading = false;
        _durationMs = stopwatch.elapsedMilliseconds;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.terminal_rounded, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Test Réponse Backend API',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Endpoint chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildEndpointChip('GET /communities', '/communities'),
                    const SizedBox(width: 8),
                    _buildEndpointChip('GET /auth/user', '/auth/user'),
                    const SizedBox(width: 8),
                    _buildEndpointChip('GET /loanables', '/loanables'),
                    const SizedBox(width: 8),
                    _buildEndpointChip('GET /status', '/status'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Status Bar
              if (_statusCode != null || _errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _errorMessage != null
                        ? AppColors.dangerBg
                        : AppColors.successBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _errorMessage != null
                            ? Icons.cancel_outlined
                            : Icons.check_circle_outline_rounded,
                        size: 18,
                        color: _errorMessage != null
                            ? AppColors.danger
                            : AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage != null
                              ? 'Erreur ($_durationMs ms)'
                              : 'HTTP $_statusCode OK ($_durationMs ms)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _errorMessage != null
                                ? AppColors.danger
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Content / JSON response viewer
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.primary),
                              SizedBox(height: 12),
                              Text(
                                'Requête en cours...',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : _errorMessage != null
                          ? SingleChildScrollView(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFFF7B72),
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: SelectableText(
                                _prettyJson(_responseData),
                                style: const TextStyle(
                                  color: Color(0xFF7EE787),
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 12),

              // Re-run button
              ElevatedButton.icon(
                onPressed: _isLoading || _endpointTested == null
                    ? null
                    : () => _runTest(_endpointTested!),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('Relancer ($_endpointTested)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndpointChip(String label, String endpoint) {
    final isSelected = _endpointTested == endpoint;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      onSelected: (_) => _runTest(endpoint),
    );
  }

  String _prettyJson(dynamic data) {
    if (data == null) return 'Aucune donnée reçue (null)';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
