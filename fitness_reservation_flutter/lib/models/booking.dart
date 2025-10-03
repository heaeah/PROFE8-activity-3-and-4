class Booking {
  final String id;
  final String userId; // NEW: Associate booking with user
  final String className;
  final String skillLevel;
  final DateTime date;
  final String time;
  final bool isGroupClass;
  final bool needsEquipment;
  final double price;
  final String paymentStatus;

  Booking({
    required this.id,
    required this.userId, // NEW
    required this.className,
    required this.skillLevel,
    required this.date,
    required this.time,
    required this.isGroupClass,
    required this.needsEquipment,
    required this.price,
    this.paymentStatus = 'unpaid',
  });

  Booking copyWith({
    String? id,
    String? userId,
    String? className,
    String? skillLevel,
    DateTime? date,
    String? time,
    bool? isGroupClass,
    bool? needsEquipment,
    double? price,
    String? paymentStatus,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      className: className ?? this.className,
      skillLevel: skillLevel ?? this.skillLevel,
      date: date ?? this.date,
      time: time ?? this.time,
      isGroupClass: isGroupClass ?? this.isGroupClass,
      needsEquipment: needsEquipment ?? this.needsEquipment,
      price: price ?? this.price,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
