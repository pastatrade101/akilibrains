import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final String totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final String phoneNumber;
  final List<String> bookIDs; // Changed to a list

  OrderModel({
    required this.id,
    required this.bookIDs, // Changed here
    required this.phoneNumber,
    this.userId = '',
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Vodacom',
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'phoneNumber': phoneNumber,
      'bookIDs': bookIDs, // Changed here
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      totalAmount: data['totalAmount'] as String,
      phoneNumber: data['totalAmount'] as String,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      bookIDs: List<String>.from(data['bookIDs'] as List<dynamic>), // Changed here
    );
  }
}
