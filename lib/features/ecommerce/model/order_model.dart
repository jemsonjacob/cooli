enum OrderStatus { placed, confirmed, packed, outForDelivery, delivered }

class OrderTimelineStep {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  const OrderTimelineStep({
    required this.title,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class OrderModel {
  final String id;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String address;
  final String paymentMethod;
  final String estimatedDelivery;
  final List<OrderTimelineStep> steps;

  const OrderModel({
    required this.id,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.estimatedDelivery,
    required this.steps,
  });
}
