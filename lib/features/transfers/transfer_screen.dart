import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examflutter/core/services/api_service.dart';
import 'package:examflutter/core/services/auth_service.dart';
import 'package:examflutter/core/utils/formatters.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isReceiverFocused = true;

  void _appendNumber(String number) {
    if (_isReceiverFocused) {
      _receiverController.text += number;
    } else {
      _amountController.text += number;
    }
    setState(() {});
  }

  void _deleteLast() {
    if (_isReceiverFocused) {
      if (_receiverController.text.isNotEmpty) {
        _receiverController.text = _receiverController.text.substring(
          0,
          _receiverController.text.length - 1,
        );
      }
    } else {
      if (_amountController.text.isNotEmpty) {
        _amountController.text = _amountController.text.substring(
          0,
          _amountController.text.length - 1,
        );
      }
    }
    setState(() {});
  }

  void _clearField() {
    if (_isReceiverFocused) {
      _receiverController.clear();
    } else {
      _amountController.clear();
    }
    setState(() {});
  }

  Future<void> _transfer() async {
    final receiver = _receiverController.text.trim();
    final amountStr = _amountController.text.trim();

    if (receiver.isEmpty || amountStr.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Veuillez remplir tous les champs',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      Fluttertoast.showToast(
        msg: 'Montant invalide',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final sender = authService.phoneNumber;

    if (sender == null) {
      Fluttertoast.showToast(
        msg: 'Utilisateur non authentifié',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (sender == receiver) {
      Fluttertoast.showToast(
        msg: 'Vous ne pouvez pas vous transférer à vous-même',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (amount > apiService.balance) {
      Fluttertoast.showToast(
        msg: 'Solde insuffisant',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await apiService.transfer(sender, receiver, amount);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Fluttertoast.showToast(
        msg: 'Transfert réussi',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      
      
      await apiService.getBalance(sender);
      await apiService.getTransactions(sender);
      
      _receiverController.clear();
      _amountController.clear();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(
        msg: result['message'] ?? 'Erreur lors du transfert',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfert d\'argent',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _clearField,
            child: const Text(
              'Effacer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Solde disponible',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(apiService.balance),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667EEA),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isReceiverFocused = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isReceiverFocused
                            ? const Color(0xFF667EEA).withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isReceiverFocused
                              ? const Color(0xFF667EEA)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _receiverController,
                        enabled: false,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: 'Numéro du destinataire',
                          hintText: '+221 77 000 00 02',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isReceiverFocused = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: !_isReceiverFocused
                            ? const Color(0xFF667EEA).withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !_isReceiverFocused
                              ? const Color(0xFF667EEA)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _amountController,
                        enabled: false,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: 'Montant',
                          hintText: '0',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.money),
                          suffixText: 'FCFA',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Frais de transfert : 0 FCFA',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _transfer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Transférer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumberButton('+', isSpecial: true),
                    _buildNumberButton('0'),
                    _buildDeleteButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number, {bool isSpecial = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: isSpecial ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _appendNumber(number),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isSpecial ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _deleteLast,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Icon(
                Icons.backspace,
                color: Colors.red,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}