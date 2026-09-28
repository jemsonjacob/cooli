import 'package:cooli/features/ecommerce/model/product_model.dart';
import 'package:cooli/features/ecommerce/model/order_model.dart';

class EcommerceRepo {
  List<ProductModel> getProducts() {
    return const [
      ProductModel(
        id: 'prod_sand',
        title: 'River Sand',
        category: 'Sand',
        price: 1200.0,
        unit: '/m³',
        rating: 4.5,
        reviewCount: 120,
        inStock: true,
        description: 'High quality river sand suitable for construction, plastering, and masonry work. Thoroughly washed and filtered.',
        imageUrl: 'assets/images/ecom_sand_clean.png',
      ),
      ProductModel(
        id: 'prod_bricks',
        title: 'Red Bricks',
        category: 'Bricks',
        price: 8500.0,
        unit: '/1000 pcs',
        rating: 4.8,
        reviewCount: 85,
        inStock: true,
        description: 'First-class kiln burnt solid red clay bricks with uniform edges and high compressive strength.',
        imageUrl: 'assets/images/ecom_bricks_clean.png',
      ),
      ProductModel(
        id: 'prod_cement',
        title: 'Portland Cement (50kg)',
        category: 'Cement',
        price: 420.0,
        unit: '/bag',
        rating: 4.7,
        reviewCount: 210,
        inStock: true,
        description: 'Premium grade 53 grade cement for structural concrete, slabs, and columns.',
        imageUrl: 'assets/images/ecom_cement_clean.png',
      ),
      ProductModel(
        id: 'prod_aggregates',
        title: '20mm Blue Metal Aggregates',
        category: 'Aggregates',
        price: 1800.0,
        unit: '/ton',
        rating: 4.6,
        reviewCount: 64,
        inStock: true,
        description: 'Machine-crushed granite stone chips for durable concrete mixtures.',
        imageUrl: 'assets/images/ecom_aggregates_clean.png',
      ),
    ];
  }

  OrderModel getSampleOrder() {
    return const OrderModel(
      id: 'CO12345',
      subtotal: 10900.0,
      deliveryFee: 250.0,
      totalAmount: 11150.0,
      address: 'Home - Kochi, Kerala',
      paymentMethod: 'UPI',
      estimatedDelivery: 'Tomorrow',
      steps: [
        OrderTimelineStep(
          title: 'Order Placed',
          time: '12 Apr, 10:24 AM',
          isCompleted: true,
        ),
        OrderTimelineStep(
          title: 'Confirmed',
          time: '12 Apr, 10:32 AM',
          isCompleted: true,
        ),
        OrderTimelineStep(
          title: 'Packed',
          time: '12 Apr, 01:15 PM',
          isCompleted: true,
          isCurrent: true,
        ),
        OrderTimelineStep(
          title: 'Out for Delivery',
          time: 'Expected by 04:00 PM',
          isCompleted: false,
        ),
        OrderTimelineStep(
          title: 'Delivered',
          time: 'Tomorrow',
          isCompleted: false,
        ),
      ],
    );
  }
}
