class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String status; // 'pending', 'completed', 'failed'
  final String cardLastFour;

  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.status,
    this.cardLastFour = '',
  });
}
