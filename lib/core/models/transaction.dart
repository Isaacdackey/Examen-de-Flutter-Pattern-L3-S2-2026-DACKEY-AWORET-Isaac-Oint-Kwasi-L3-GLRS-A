import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String type;
  final double amount;
  final double fees;
  final String description;
  final String? targetPhone;
  final String createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fees,
    required this.description,
    this.targetPhone,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      fees: (json['fees'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      targetPhone: json['targetPhone'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  bool get isCredit {
    return type == 'DEPOT' || type == 'TRANSFERT_RECEPTION';
  }

  bool get isDebit {
    return type == 'RETRAIT' || type == 'TRANSFERT_ENVOI' || type == 'PAIEMENT_FACTURE';
  }

  IconData getIcon() {
    switch (type) {
      case 'DEPOT':
        return Icons.arrow_downward;
      case 'RETRAIT':
        return Icons.arrow_upward;
      case 'TRANSFERT_ENVOI':
        return Icons.send;
      case 'TRANSFERT_RECEPTION':
        return Icons.inbox;
      case 'PAIEMENT_FACTURE':
        return Icons.receipt;
      default:
        return Icons.circle;
    }
  }

  Color getColor() {
    return isCredit ? Colors.green : Colors.red;
  }

  String getLabel() {
    switch (type) {
      case 'DEPOT':
        return 'Dépôt';
      case 'RETRAIT':
        return 'Retrait';
      case 'TRANSFERT_ENVOI':
        return 'Transfert envoyé';
      case 'TRANSFERT_RECEPTION':
        return 'Transfert reçu';
      case 'PAIEMENT_FACTURE':
        return 'Paiement facture';
      default:
        return type;
    }
  }
}