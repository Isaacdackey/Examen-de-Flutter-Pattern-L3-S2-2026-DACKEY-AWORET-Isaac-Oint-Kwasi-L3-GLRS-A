class Facture {
  final int id;
  final String reference;
  final String walletCode;
  final String serviceName;
  final double montant;
  final bool payee;
  final String dateFacture;
  final String? datePaiement;

  Facture({
    required this.id,
    required this.reference,
    required this.walletCode,
    required this.serviceName,
    required this.montant,
    required this.payee,
    required this.dateFacture,
    this.datePaiement,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'] ?? 0,
      reference: json['reference'] ?? '',
      walletCode: json['walletCode'] ?? '',
      serviceName: json['serviceName'] ?? '',
      montant: (json['montant'] ?? 0).toDouble(),
      payee: json['payee'] ?? false,
      dateFacture: json['dateFacture'] ?? '',
      datePaiement: json['datePaiement'],
    );
  }
}
