import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examflutter/core/services/api_service.dart';
import 'package:examflutter/core/models/transaction.dart';
import 'package:examflutter/core/utils/formatters.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filterType = 'ALL';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final transactions = _filterTransactions(apiService.transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historique',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Rechercher...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterType,
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('Tous')),
                    DropdownMenuItem(value: 'DEPOT', child: Text('Dépôts')),
                    DropdownMenuItem(value: 'RETRAIT', child: Text('Retraits')),
                    DropdownMenuItem(
                      value: 'TRANSFERT_ENVOI',
                      child: Text('Envoyés'),
                    ),
                    DropdownMenuItem(
                      value: 'TRANSFERT_RECEPTION',
                      child: Text('Reçus'),
                    ),
                    DropdownMenuItem(
                      value: 'PAIEMENT_FACTURE',
                      child: Text('Paiements'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _filterType = value ?? 'ALL');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: apiService.isLoading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune transaction',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.isCredit
                                    ? Colors.green[100]
                                    : Colors.red[100],
                                child: Icon(
                                  tx.getIcon(),
                                  color: tx.isCredit
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                tx.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                Formatters.formatDate(tx.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${tx.isCredit ? '+' : '-'} ${Formatters.formatCurrency(tx.amount)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: tx.isCredit
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  if (tx.fees > 0)
                                    Text(
                                      'Frais: ${Formatters.formatCurrency(tx.fees)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
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

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    var filtered = transactions;

    if (_filterType != 'ALL') {
      filtered = filtered.where((tx) => tx.type == _filterType).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((tx) {
        return tx.description.toLowerCase().contains(query) ||
            (tx.targetPhone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }
}