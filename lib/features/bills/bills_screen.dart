import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examflutter/core/services/api_service.dart';
import 'package:examflutter/core/services/auth_service.dart';
import 'package:examflutter/core/models/facture.dart';
import 'package:examflutter/core/utils/formatters.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Facture> _factures = [];
  bool _isLoading = false;
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    setState(() => _isLoading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final phone = authService.phoneNumber;

    if (phone != null) {
      final response = await apiService.getWalletByPhone(phone);
      if (response['success'] == true) {
        final wallet = response['data'];
        final walletCode = wallet['code'];
        await apiService.getBills(walletCode);
        _factures = apiService.factures.where((f) => !f.payee).toList();
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _payBills() async {
    if (_selectedIds.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Sélectionnez au moins une facture',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    final apiService = Provider.of<ApiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final phone = authService.phoneNumber;

    if (phone == null) return;

    final selected = _factures.where((f) => _selectedIds.contains(f.id)).toList();
    final total = selected.fold(0.0, (sum, f) => sum + f.montant);

    if (total > apiService.balance) {
      Fluttertoast.showToast(
        msg: 'Solde insuffisant',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final references = selected.map((f) => f.reference).toList();
    final result = await apiService.payBills(
      phone,
      selected.first.serviceName,
      references,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Fluttertoast.showToast(
        msg: '${selected.length} facture(s) payée(s)',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      _selectedIds.clear();
      await _loadBills();
    } else {
      Fluttertoast.showToast(
        msg: result['message'] ?? 'Erreur lors du paiement',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Factures',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _payBills,
            icon: const Icon(Icons.payment),
            tooltip: 'Payer',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _factures.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'Aucune facture impayée',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedIds.length} sélectionnée(s)',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Total: ${Formatters.formatCurrency(_selectedIds.fold(0.0, (sum, id) {
                              final facture = _factures.firstWhere((f) => f.id == id);
                              return sum + facture.montant;
                            }))}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667EEA),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _factures.length,
                        itemBuilder: (context, index) {
                          final facture = _factures[index];
                          final isSelected = _selectedIds.contains(facture.id);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedIds.add(facture.id);
                                  } else {
                                    _selectedIds.remove(facture.id);
                                  }
                                });
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          facture.serviceName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Réf: ${facture.reference}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Date: ${Formatters.formatShortDate(facture.dateFacture)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        _getServiceIcon(facture.serviceName),
                                        color: const Color(0xFF667EEA),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        Formatters.formatCurrency(facture.montant),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'ISM':
        return Icons.school;
      case 'WOYAFAL':
        return Icons.electric_bolt;
      case 'RAPIDO':
        return Icons.speed;
      default:
        return Icons.receipt;
    }
  }
}