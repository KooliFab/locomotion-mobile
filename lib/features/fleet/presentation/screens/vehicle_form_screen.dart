// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../controllers/fleet_controller.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  final int? vehicleId;
  final FleetVehicle? initialVehicle;

  const VehicleFormScreen({super.key, this.vehicleId, this.initialVehicle});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isInit = false;
  bool _isSubmitting = false;
  String? _serverError;
  String? _idempotencyKey;
  FleetVehicle? _loadedVehicle;

  // General fields
  late String _type;
  final _nameController = TextEditingController();
  String _sharingMode = 'on_demand';
  final _locationController = TextEditingController();
  final _minDurationController = TextEditingController(text: '30');
  final _maxDurationController = TextEditingController(text: '1440');
  final _instructionsController = TextEditingController();
  final _returnInstructionsController = TextEditingController();
  final _trustedInstructionsController = TextEditingController();
  final _commentsController = TextEditingController();

  // Car specific fields
  final _carBrandController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  String _carEngine = 'fuel';
  String _carTransmission = 'automatic';
  final _carPlateController = TextEditingController();
  final _carInsurerController = TextEditingController();
  String _carPapersLocation = 'in_the_car';
  String _carPricingCategory = 'small';
  String _carValueCategory = 'lte50k';

  // Bike specific fields
  String _bikeType = 'regular';
  final _bikeModelController = TextEditingController();
  String _bikeSize = 'medium';

  // Trailer specific fields
  final _trailerModelController = TextEditingController();

  bool get isEditMode => widget.vehicleId != null;
  bool get isCar => _type == 'car';
  bool get isBike => _type == 'bike';
  bool get isTrailer => _type == 'trailer' || _type == 'car_trailer';

  bool get areCarTechnicalFieldsLocked {
    if (!isEditMode || !isCar) return false;
    final vehicle = _loadedVehicle ?? widget.initialVehicle;
    return vehicle?.published == true;
  }

  @override
  void initState() {
    super.initState();
    _type = 'bike';
    _idempotencyKey = _generateUuidV4();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.initialVehicle != null) {
        _populateFromVehicle(widget.initialVehicle!);
      } else if (isEditMode) {
        _loadVehicle();
      }
      _isInit = true;
    }
  }

  Future<void> _loadVehicle() async {
    final vehicle = await ref.read(
      fleetVehicleDetailProvider(widget.vehicleId!).future,
    );
    if (vehicle != null && mounted) {
      _populateFromVehicle(vehicle);
    }
  }

  void _populateFromVehicle(FleetVehicle v) {
    _loadedVehicle = v;
    _type = v.type;
    _nameController.text = v.name;
    _sharingMode = v.sharingMode ?? 'on_demand';
    _locationController.text = v.locationDescription ?? '';
    _minDurationController.text =
        v.minLoanDurationInMinutes?.toString() ?? '30';
    _maxDurationController.text =
        v.maxLoanDurationInMinutes?.toString() ?? '1440';
    _instructionsController.text = v.instructions ?? '';
    _returnInstructionsController.text = v.returnInstructions ?? '';
    _trustedInstructionsController.text = v.trustedBorrowerInstructions ?? '';
    _commentsController.text = v.comments ?? '';

    final d = v.details ?? {};
    if (v.isCar) {
      _carBrandController.text = d['brand']?.toString() ?? '';
      _carModelController.text = d['model']?.toString() ?? '';
      _carYearController.text = d['year_of_circulation']?.toString() ?? '';
      _carEngine = d['engine']?.toString() ?? 'fuel';
      _carTransmission = d['transmission_mode']?.toString() ?? 'automatic';
      _carPlateController.text = d['plate_number']?.toString() ?? '';
      _carInsurerController.text = d['insurer']?.toString() ?? '';
      _carPapersLocation = d['papers_location']?.toString() ?? 'in_the_car';
      _carPricingCategory = d['pricing_category']?.toString() ?? 'small';
      _carValueCategory = d['value_category']?.toString() ?? 'lte50k';
    } else if (v.isBike) {
      _bikeType = d['bike_type']?.toString() ?? 'regular';
      _bikeModelController.text = d['model']?.toString() ?? '';
      _bikeSize = d['size']?.toString() ?? 'medium';
    } else if (v.isTrailer) {
      _trailerModelController.text = d['model']?.toString() ?? '';
    }

    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _minDurationController.dispose();
    _maxDurationController.dispose();
    _instructionsController.dispose();
    _returnInstructionsController.dispose();
    _trustedInstructionsController.dispose();
    _commentsController.dispose();

    _carBrandController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    _carPlateController.dispose();
    _carInsurerController.dispose();

    _bikeModelController.dispose();
    _trailerModelController.dispose();
    super.dispose();
  }

  String _generateUuidV4() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    return [
      for (int i = 0; i < 16; i++) ...[
        if (i == 4 || i == 6 || i == 8 || i == 10) '-',
        bytes[i].toRadixString(16).padLeft(2, '0'),
      ],
    ].join();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _serverError = null;
    });

    final currentUser = ref.read(authControllerProvider).value;

    final payload = <String, dynamic>{
      'type': _type,
      'name': _nameController.text.trim(),
      'sharing_mode': _sharingMode,
      'location_description': _locationController.text.trim(),
      'min_loan_duration_in_minutes': int.tryParse(_minDurationController.text),
      'max_loan_duration_in_minutes': int.tryParse(_maxDurationController.text),
      'instructions': _instructionsController.text.trim(),
      'return_instructions': _returnInstructionsController.text.trim(),
      'trusted_borrower_instructions': _trustedInstructionsController.text
          .trim(),
      'comments': _commentsController.text.trim(),
      'position': [45.5017, -73.5673], // Coordonnées par défaut si non éditées
    };

    if (!isEditMode && currentUser != null) {
      payload['owner_user'] = {'id': currentUser.id};
    }

    // Type details
    if (isCar) {
      if (!areCarTechnicalFieldsLocked) {
        payload['details'] = {
          'brand': _carBrandController.text.trim(),
          'model': _carModelController.text.trim(),
          'year_of_circulation': int.tryParse(_carYearController.text),
          'engine': _carEngine,
          'transmission_mode': _carTransmission,
          'plate_number': _carPlateController.text.trim(),
          'insurer': _carInsurerController.text.trim(),
          'papers_location': _carPapersLocation,
          'pricing_category': _carPricingCategory,
          'value_category': _carValueCategory,
          'has_onboard_notebook': true,
          'has_report_in_notebook': true,
          'has_informed_insurer': true,
        };
      } else {
        // Only non-technical fields can be patched
        payload['details'] = {
          'insurer': _carInsurerController.text.trim(),
          'papers_location': _carPapersLocation,
        };
      }
    } else if (isBike) {
      payload['details'] = {
        'bike_type': _bikeType,
        'model': _bikeModelController.text.trim(),
        'size': _bikeSize,
      };
    } else if (isTrailer) {
      payload['details'] = {'model': _trailerModelController.text.trim()};
    }

    try {
      if (isEditMode) {
        final vehicle = _loadedVehicle ?? widget.initialVehicle;
        await ref
            .read(ownerFleetControllerProvider.notifier)
            .updateVehicle(
              widget.vehicleId!,
              payload,
              lockVersion: vehicle?.updatedAt,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Véhicule mis à jour avec succès.')),
          );
          context.pop();
        }
      } else {
        await ref
            .read(ownerFleetControllerProvider.notifier)
            .createVehicle(payload, idempotencyKey: _idempotencyKey);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Véhicule créé avec succès.')),
          );
          context.pop();
        }
      }
    } on ConflictException catch (e) {
      if (mounted) {
        _showConflictDialog(e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _serverError = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showConflictDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Expanded(child: Text('Conflit de modification (409)')),
          ],
        ),
        content: Text(
          '$message\n\nPour éviter d\'écraser les modifications apportées par un autre gestionnaire, rechargez les données les plus récentes du véhicule.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: const Text('Fermer sans écraser'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _loadVehicle();
            },
            child: const Text('Recharger les données'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Modifier le véhicule' : 'Nouveau véhicule'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_serverError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.danger),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _serverError!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (areCarTechnicalFieldsLocked) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 20,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Champs techniques verrouillés : cette voiture est déjà publiée. Par mesure de conformité et d\'assurance, la marque, le modèle, la motorisation et l\'immatriculation ne peuvent plus être modifiés directement. Contactez un administrateur LocoMotion si nécessaire.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Section 1: Type & Informations de base
              _buildSectionCard(
                title: '1. Informations générales',
                children: [
                  if (!isEditMode) ...[
                    const Text(
                      'Type de véhicule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'bike',
                          label: Text('Vélo'),
                          icon: Icon(Icons.pedal_bike_rounded),
                        ),
                        ButtonSegment(
                          value: 'car',
                          label: Text('Voiture'),
                          icon: Icon(Icons.directions_car_rounded),
                        ),
                        ButtonSegment(
                          value: 'trailer',
                          label: Text('Remorque'),
                          icon: Icon(Icons.rv_hookup_rounded),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (set) =>
                          setState(() => _type = set.first),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextFormField(
                    key: const Key('vehicle_name_field'),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du véhicule *',
                      hintText: 'Ex. Vélo cargo familial, Toyota Prius...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Nom requis' : null,
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _sharingMode,
                    decoration: const InputDecoration(
                      labelText: 'Mode de partage *',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'on_demand',
                        child: Text('Sur demande (validation manuelle)'),
                      ),
                      DropdownMenuItem(
                        value: 'self_service',
                        child: Text('Libre-service (immédiat)'),
                      ),
                      DropdownMenuItem(
                        value: 'hybrid',
                        child: Text('Hybride (selon profil emprunteur)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _sharingMode = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    key: const Key('location_description_field'),
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Description de l\'emplacement *',
                      hintText:
                          'Ex. Stationné dans l\'allée ouest, boîte à clés au mur',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Emplacement requis'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minDurationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Durée min (minutes)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _maxDurationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Durée max (minutes)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Section 2: Détails techniques par type
              if (isCar) _buildCarSection(),
              if (isBike) _buildBikeSection(),
              if (isTrailer) _buildTrailerSection(),
              const SizedBox(height: 16),

              // Section 3: Instructions & Accès
              _buildSectionCard(
                title: '3. Instructions & Recommandations',
                children: [
                  TextFormField(
                    controller: _instructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Instructions de départ',
                      hintText: 'Comment récupérer la clé, code du cadenas...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _returnInstructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Instructions de retour',
                      hintText:
                          'Brancher la batterie, replacer la clé dans le boîtier...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _trustedInstructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Instructions emprunteur de confiance',
                      hintText:
                          'Informations confidentielles additionnelles...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _commentsController,
                    decoration: const InputDecoration(
                      labelText: 'Remarques générales',
                      hintText: 'Véhicule non fumeur, accessoires fournis...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  key: const Key('submit_vehicle_button'),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isEditMode
                              ? 'Enregistrer les modifications'
                              : 'Créer le véhicule',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarSection() {
    final locked = areCarTechnicalFieldsLocked;

    return _buildSectionCard(
      title: '2. Caractéristiques de l\'automobile',
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _carBrandController,
                enabled: !locked,
                decoration: InputDecoration(
                  labelText: 'Marque *',
                  hintText: 'Ex. Toyota',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                validator: (v) => !locked && (v == null || v.trim().isEmpty)
                    ? 'Requis'
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _carModelController,
                enabled: !locked,
                decoration: InputDecoration(
                  labelText: 'Modèle *',
                  hintText: 'Ex. Prius Prime',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                validator: (v) => !locked && (v == null || v.trim().isEmpty)
                    ? 'Requis'
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _carYearController,
                enabled: !locked,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Année *',
                  hintText: 'Ex. 2022',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                validator: (v) => !locked && (v == null || v.trim().isEmpty)
                    ? 'Requis'
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _carPlateController,
                enabled: !locked,
                decoration: InputDecoration(
                  labelText: 'Immatriculation *',
                  hintText: 'Ex. ABC-123',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                validator: (v) => !locked && (v == null || v.trim().isEmpty)
                    ? 'Requis'
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _carEngine,
                decoration: InputDecoration(
                  labelText: 'Motorisation',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                items: const [
                  DropdownMenuItem(value: 'fuel', child: Text('Essence')),
                  DropdownMenuItem(
                    value: 'electric',
                    child: Text('Électrique'),
                  ),
                  DropdownMenuItem(value: 'hybrid', child: Text('Hybride')),
                  DropdownMenuItem(value: 'diesel', child: Text('Diesel')),
                ],
                onChanged: locked
                    ? null
                    : (val) {
                        if (val != null) setState(() => _carEngine = val);
                      },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _carTransmission,
                decoration: InputDecoration(
                  labelText: 'Boîte de vitesse',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'automatic',
                    child: Text('Automatique'),
                  ),
                  DropdownMenuItem(value: 'manual', child: Text('Manuelle')),
                ],
                onChanged: locked
                    ? null
                    : (val) {
                        if (val != null) setState(() => _carTransmission = val);
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _carPricingCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie tarif',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                items: const [
                  DropdownMenuItem(value: 'small', child: Text('Petite')),
                  DropdownMenuItem(value: 'medium', child: Text('Moyenne')),
                  DropdownMenuItem(value: 'large', child: Text('Grande')),
                ],
                onChanged: locked
                    ? null
                    : (val) {
                        if (val != null) {
                          setState(() => _carPricingCategory = val);
                        }
                      },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _carValueCategory,
                decoration: InputDecoration(
                  labelText: 'Valeur du véhicule',
                  border: const OutlineInputBorder(),
                  suffixIcon: locked ? const Icon(Icons.lock, size: 18) : null,
                ),
                items: const [
                  DropdownMenuItem(value: 'lte50k', child: Text('≤ 50 000 \$')),
                  DropdownMenuItem(value: 'gt50k', child: Text('> 50 000 \$')),
                ],
                onChanged: locked
                    ? null
                    : (val) {
                        if (val != null) {
                          setState(() => _carValueCategory = val);
                        }
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Unlocked fields (Insurer & Papers)
        TextFormField(
          controller: _carInsurerController,
          decoration: const InputDecoration(
            labelText: 'Compagnie d\'assurance',
            hintText: 'Ex. Intact, Desjardins...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),

        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _carPapersLocation,
          decoration: const InputDecoration(
            labelText: 'Emplacement des papiers du véhicule',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: 'in_the_car',
              child: Text('Dans la boîte à gants'),
            ),
            DropdownMenuItem(
              value: 'with_owner',
              child: Text('Remis en main propre par le propriétaire'),
            ),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _carPapersLocation = val);
          },
        ),
      ],
    );
  }

  Widget _buildBikeSection() {
    return _buildSectionCard(
      title: '2. Caractéristiques du vélo',
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _bikeType,
          decoration: const InputDecoration(
            labelText: 'Type de vélo *',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'regular', child: Text('Vélo standard')),
            DropdownMenuItem(value: 'electric', child: Text('Vélo électrique')),
            DropdownMenuItem(
              value: 'cargo',
              child: Text('Vélo cargo / biporteur'),
            ),
            DropdownMenuItem(value: 'child', child: Text('Vélo enfant')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _bikeType = val);
          },
        ),
        const SizedBox(height: 14),

        TextFormField(
          key: const Key('bike_model_field'),
          controller: _bikeModelController,
          decoration: const InputDecoration(
            labelText: 'Modèle *',
            hintText: 'Ex. Speed 500, Trek FX...',
            border: OutlineInputBorder(),
          ),
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'Modèle requis' : null,
        ),
        const SizedBox(height: 14),

        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _bikeSize,
          decoration: const InputDecoration(
            labelText: 'Taille du cadre',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Petit (S)')),
            DropdownMenuItem(value: 'medium', child: Text('Moyen (M)')),
            DropdownMenuItem(value: 'large', child: Text('Grand (L)')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _bikeSize = val);
          },
        ),
      ],
    );
  }

  Widget _buildTrailerSection() {
    return _buildSectionCard(
      title: '2. Caractéristiques de la remorque',
      children: [
        TextFormField(
          key: const Key('trailer_model_field'),
          controller: _trailerModelController,
          decoration: const InputDecoration(
            labelText: 'Modèle ou dimensions *',
            hintText: 'Ex. Burley Coho XC, Remorque plateau 100kg...',
            border: OutlineInputBorder(),
          ),
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'Modèle requis' : null,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}
