import '../models/user.dart';
import '../models/booking.dart';
import '../models/payment.dart';

class AppData {
  static final List<User> users = [];
  static final List<Booking> bookings = [];
  static final List<Payment> payments = [];
  static User? currentUser;

  // Class pricing
  static const Map<String, double> classPrices = {
    'Yoga': 25.0,
    'Cardio': 30.0,
    'Strength': 35.0,
  };

  static double getClassPrice(String classType) {
    return classPrices[classType] ?? 25.0;
  }

  static double calculateTotal(
      double basePrice, bool isGroupClass, bool needsEquipment) {
    double total = basePrice;
    if (isGroupClass) {
      total *= 0.8; // 20% discount for group classes
    }
    if (needsEquipment) {
      total += 10.0; // Equipment rental fee
    }
    return total;
  }

  // NEW: Get bookings for current user only
  static List<Booking> getCurrentUserBookings() {
    if (currentUser == null) return [];
    return bookings.where((b) => b.userId == currentUser!.email).toList();
  }

  // NEW: Get payments for current user only
  static List<Payment> getCurrentUserPayments() {
    if (currentUser == null) return [];
    final userBookingIds = getCurrentUserBookings().map((b) => b.id).toSet();
    return payments.where((p) => userBookingIds.contains(p.bookingId)).toList();
  }
}
