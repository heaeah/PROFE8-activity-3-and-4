import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/booking.dart';
import '../models/payment.dart';
import '../services/app_data.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    // Only validate card fields if payment method is card-based
    if (_selectedPaymentMethod.contains('Card')) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Get last 4 digits based on payment method
    String lastFour = '';
    if (_selectedPaymentMethod.contains('Card')) {
      lastFour = _cardNumberController.text.substring(
        _cardNumberController.text.length - 4,
      );
    } else {
      lastFour = '****'; // For non-card payments
    }

    // Create payment record
    final payment = Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookingId: widget.booking.id,
      amount: widget.booking.price,
      paymentMethod: _selectedPaymentMethod,
      paymentDate: DateTime.now(),
      status: 'completed',
      cardLastFour: lastFour,
    );

    AppData.payments.add(payment);

    // Update booking payment status
    final bookingIndex =
        AppData.bookings.indexWhere((b) => b.id == widget.booking.id);
    if (bookingIndex != -1) {
      AppData.bookings[bookingIndex] = widget.booking.copyWith(
        paymentStatus: 'paid',
      );
    }

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      // Show success dialog with fixed overflow
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Flexible(
                child: Text('Payment Successful!'),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \$${widget.booking.price.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text('Method: $_selectedPaymentMethod'),
                const SizedBox(height: 4),
                Text(
                  'ID: ${payment.id}',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to previous screen
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Booking Summary Card
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Class: ${widget.booking.className}'),
                      Text('Level: ${widget.booking.skillLevel}'),
                      Text(
                          'Date: ${widget.booking.date.toString().split(' ')[0]}'),
                      Text('Time: ${widget.booking.time}'),
                      if (widget.booking.isGroupClass)
                        const Text('Type: Group Class (20% discount)'),
                      if (widget.booking.needsEquipment)
                        const Text('Equipment Rental: +\$10.00'),
                      const Divider(height: 24),
                      Text(
                        'Total: \$${widget.booking.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method Selection
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.payment),
                ),
                items: ['Credit Card', 'Debit Card', 'PayPal', 'GCash']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Card Details (shown for card payments)
              if (_selectedPaymentMethod.contains('Card')) ...[
                const Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    prefixIcon: Icon(Icons.credit_card),
                    hintText: '1234 5678 9012 3456',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    if (value.length < 16) {
                      return 'Card number must be 16 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(
                    labelText: 'Card Holder Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card holder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry (MM/YY)',
                          prefixIcon: Icon(Icons.calendar_today),
                          hintText: '12/25',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 4) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          prefixIcon: Icon(Icons.lock),
                          hintText: '123',
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 3) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],

              // For non-card payments, show info message
              if (!_selectedPaymentMethod.contains('Card')) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You will be redirected to $_selectedPaymentMethod to complete payment.',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Pay Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Pay \$${widget.booking.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
