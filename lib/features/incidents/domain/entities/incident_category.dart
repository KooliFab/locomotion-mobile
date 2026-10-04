import 'package:flutter/material.dart';

enum IncidentCategory {
  damage(
    code: 'damage',
    label: 'Dommage matériel',
    description: 'Rayure, choc, carrosserie, bris de glace sans immobilisation',
    backendType: 'small_incident',
    prefix: '[Dommage]',
    icon: Icons.car_crash_outlined,
    isPotentiallyBlocking: false,
    requiresSafetyDisclaimer: false,
  ),
  puncture(
    code: 'puncture',
    label: 'Crevaison / Pneu',
    description: 'Pneu à plat, détérioré ou roue endommagée',
    backendType: 'small_incident',
    prefix: '[Crevaison]',
    icon: Icons.tire_repair,
    isPotentiallyBlocking: false,
    requiresSafetyDisclaimer: false,
  ),
  breakdown(
    code: 'breakdown',
    label: 'Panne mécanique',
    description: 'Batterie à plat, moteur, freins ou problème technique',
    backendType: 'small_incident',
    prefix: '[Panne]',
    icon: Icons.build_circle_outlined,
    isPotentiallyBlocking: false,
    requiresSafetyDisclaimer: true,
  ),
  delay(
    code: 'delay',
    label: 'Retard de restitution',
    description: 'Impossibilité de rendre le véhicule à l\'heure prévue (non bloquant)',
    backendType: 'general',
    prefix: '[Retard]',
    icon: Icons.access_time_rounded,
    isPotentiallyBlocking: false,
    requiresSafetyDisclaimer: false,
  ),
  accident(
    code: 'accident',
    label: 'Accident / Collision',
    description: 'Collision avec un tiers ou obstacle (bloque le véhicule pour inspection)',
    backendType: 'accident',
    prefix: '[Accident]',
    icon: Icons.warning_amber_rounded,
    isPotentiallyBlocking: true,
    requiresSafetyDisclaimer: true,
  ),
  other(
    code: 'other',
    label: 'Autre problème',
    description: 'Propreté anormale, équipement manquant ou litige divers',
    backendType: 'general',
    prefix: '[Autre]',
    icon: Icons.report_problem_outlined,
    isPotentiallyBlocking: false,
    requiresSafetyDisclaimer: false,
  );

  final String code;
  final String label;
  final String description;
  final String backendType;
  final String prefix;
  final IconData icon;
  final bool isPotentiallyBlocking;
  final bool requiresSafetyDisclaimer;

  const IncidentCategory({
    required this.code,
    required this.label,
    required this.description,
    required this.backendType,
    required this.prefix,
    required this.icon,
    required this.isPotentiallyBlocking,
    required this.requiresSafetyDisclaimer,
  });

  /// Parse category from comments prefix or backend enum
  static IncidentCategory fromCommentsOrType(String? comments, String? backendType) {
    if (comments != null) {
      final trimmed = comments.trim().toLowerCase();
      if (trimmed.startsWith('[retard]')) return IncidentCategory.delay;
      if (trimmed.startsWith('[crevaison]')) return IncidentCategory.puncture;
      if (trimmed.startsWith('[panne]')) return IncidentCategory.breakdown;
      if (trimmed.startsWith('[dommage]')) return IncidentCategory.damage;
      if (trimmed.startsWith('[accident]')) return IncidentCategory.accident;
      if (trimmed.startsWith('[autre]')) return IncidentCategory.other;
    }

    switch (backendType?.toLowerCase()) {
      case 'accident':
        return IncidentCategory.accident;
      case 'puncture':
      case 'crevaison':
        return IncidentCategory.puncture;
      case 'breakdown':
      case 'panne':
        return IncidentCategory.breakdown;
      case 'delay':
      case 'retard':
        return IncidentCategory.delay;
      case 'small_incident':
      case 'damage':
      case 'dommage':
        return IncidentCategory.damage;
      case 'general':
      case 'other':
      default:
        return IncidentCategory.other;
    }
  }

  /// Parse category directly from backend incident_type string
  static IncidentCategory fromBackend(String? backendType) =>
      fromCommentsOrType(null, backendType);

  /// Strip prefix from comments for clean display
  static String stripPrefix(String comments) {
    var result = comments.trim();
    final lower = result.toLowerCase();
    for (final cat in IncidentCategory.values) {
      if (lower.startsWith(cat.prefix.toLowerCase())) {
        result = result.substring(cat.prefix.length).trim();
        break;
      }
    }
    return result;
  }
}
