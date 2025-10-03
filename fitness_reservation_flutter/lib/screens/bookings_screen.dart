import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/app_data.dart';
import 'payment_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings & Payments'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Bookings'),
              Tab(icon: Icon(Icons.payment), text: 'Payments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(),
            _buildPaymentHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    final userBookings = AppData.getCurrentUserBookings();

    if (userBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userBookings.length,
      itemBuilder: (context, index) {
        final booking = userBookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: booking.paymentStatus == 'paid'
                  ? Colors.green
                  : Colors.orange,
              child: Icon(
                booking.paymentStatus == 'paid'
                    ? Icons.check_circle
                    : Icons.pending_actions,
                color: Colors.white,
              ),
            ),
            title: Text(
              booking.className,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Level: ${booking.skillLevel}'),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(booking.date)} at ${booking.time}',
                ),
                Text(
                  '\$${booking.price.toStringAsFixed(2)} • ${booking.paymentStatus.toUpperCase()}',
                  style: TextStyle(
                    color: booking.paymentStatus == 'paid'
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (booking.isGroupClass || booking.needsEquipment)
                  Row(
                    children: [
                      if (booking.isGroupClass)
                        const Chip(
                          label: Text('Group', style: TextStyle(fontSize: 10)),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      if (booking.isGroupClass && booking.needsEquipment)
                        const SizedBox(width: 4),
                      if (booking.needsEquipment)
                        const Chip(
                          label:
                              Text('Equipment', style: TextStyle(fontSize: 10)),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
              ],
            ),
            trailing: booking.paymentStatus == 'unpaid'
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(booking: booking),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pay Now'),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _cancelBooking(index),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentHistory() {
    final userPayments = AppData.getCurrentUserPayments();

    if (userPayments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No payment history',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userPayments.length,
      itemBuilder: (context, index) {
        final payment = userPayments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  payment.status == 'completed' ? Colors.green : Colors.red,
              child: Icon(
                payment.status == 'completed'
                    ? Icons.check_circle
                    : Icons.error,
                color: Colors.white,
              ),
            ),
            title: Text(
              '\$${payment.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${payment.paymentMethod} •••• ${payment.cardLastFour}'),
                Text(DateFormat('MMM dd, yyyy HH:mm')
                    .format(payment.paymentDate)),
                Text(
                  payment.status.toUpperCase(),
                  style: TextStyle(
                    color: payment.status == 'completed'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.receipt),
          ),
        );
      },
    );
  }

  void _cancelBooking(int index) {
    final userBookings = AppData.getCurrentUserBookings();
    final booking = userBookings[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppData.bookings.removeWhere((b) => b.id == booking.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled')),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
