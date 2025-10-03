import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../services/app_data.dart';
import 'payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _classNameController = TextEditingController();
  String _selectedSkillLevel = 'Beginner';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isGroupClass = false;
  bool _needsEquipment = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final classType = ['Yoga', 'Cardio', 'Strength'][_tabController.index];
      final basePrice = AppData.getClassPrice(classType);
      final totalPrice = AppData.calculateTotal(
        basePrice,
        _isGroupClass,
        _needsEquipment,
      );

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: AppData.currentUser!.email, // User association
        className: _classNameController.text,
        skillLevel: _selectedSkillLevel,
        date: _selectedDate,
        time: _selectedTime.format(context),
        isGroupClass: _isGroupClass,
        needsEquipment: _needsEquipment,
        price: totalPrice,
        paymentStatus: 'unpaid',
      );

      AppData.bookings.add(booking);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(booking: booking),
        ),
      ).then((paymentSuccess) {
        if (paymentSuccess == true) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Class booked and paid successfully!')),
          );
        } else {
          AppData.bookings.removeWhere((b) => b.id == booking.id);
        }
      });

      _formKey.currentState!.reset();
      _classNameController.clear();
      setState(() {
        _selectedSkillLevel = 'Beginner';
        _isGroupClass = false;
        _needsEquipment = false;
      });
    }
  }

  void _showClassName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Class Name'),
        content: Text(
          _classNameController.text.isEmpty
              ? 'No class name entered'
              : 'Class: ${_classNameController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.teal,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.fitness_center), text: 'Yoga'),
              Tab(icon: Icon(Icons.directions_run), text: 'Cardio'),
              Tab(icon: Icon(Icons.sports_gymnastics), text: 'Strength'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingForm('Yoga'),
              _buildBookingForm('Cardio'),
              _buildBookingForm('Strength'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingForm(String classType) {
    final basePrice = AppData.getClassPrice(classType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Book a $classType Class',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Base Price: \$${basePrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _classNameController,
              decoration: const InputDecoration(
                labelText: 'Class Name',
                prefixIcon: Icon(Icons.class_),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a class name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _showClassName,
              icon: const Icon(Icons.visibility),
              label: const Text('Show Class Name'),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedSkillLevel,
              decoration: const InputDecoration(
                labelText: 'Skill Level',
                prefixIcon: Icon(Icons.trending_up),
              ),
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkillLevel = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              title: const Text('Group Class'),
              subtitle: const Text('Join with others (20% discount)'),
              value: _isGroupClass,
              onChanged: (value) {
                setState(() {
                  _isGroupClass = value!;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('Equipment Needed'),
              subtitle: const Text('Requires special equipment (+\$10.00)'),
              value: _needsEquipment,
              onChanged: (value) {
                setState(() {
                  _needsEquipment = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Breakdown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Price:'),
                      Text('\$${basePrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (_isGroupClass)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Group Discount (20%):'),
                        Text('-\$${(basePrice * 0.2).toStringAsFixed(2)}'),
                      ],
                    ),
                  if (_needsEquipment)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Equipment Rental:'),
                        Text('+\$10.00'),
                      ],
                    ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\$${AppData.calculateTotal(basePrice, _isGroupClass, _needsEquipment).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue to Payment'),
            ),
            const SizedBox(height: 32),

            // Display only current user's bookings
            if (AppData.getCurrentUserBookings().isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Your Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...AppData.getCurrentUserBookings().map((booking) => Card(
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
                      title: Text(booking.className),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${booking.skillLevel} • ${DateFormat('MMM dd').format(booking.date)} at ${booking.time}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${booking.price.toStringAsFixed(2)} • ${booking.paymentStatus.toUpperCase()}',
                            style: TextStyle(
                              color: booking.paymentStatus == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: booking.paymentStatus == 'unpaid'
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScreen(booking: booking),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Pay Now'),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (booking.isGroupClass)
                                  const Icon(Icons.group,
                                      size: 16, color: Colors.grey),
                                if (booking.needsEquipment)
                                  const Icon(Icons.fitness_center,
                                      size: 16, color: Colors.grey),
                              ],
                            ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
