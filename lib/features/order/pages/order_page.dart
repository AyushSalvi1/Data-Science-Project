import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/extension.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_order_bloc/get_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/models/order_model.dart';
import 'package:flutter_ecommerce/features/order/widgets/empty_order_view.dart';
import 'package:gap/gap.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetOrderBloc>(context).add(GetOrderEvent.get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: BlocBuilder<GetOrderBloc, GetOrderState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (failure) => Center(child: Text(failure.toString())),
            loaded: (orders) => orders.isEmpty
                ? const EmptyOrderView()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildOrderHeader(order),
                              const SizedBox(height: 10),
                              _buildOrderDetails(order),
                              const SizedBox(height: 10),
                              _buildOrderFooter(order),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  /// Order ID & Status
  Widget _buildOrderHeader(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Order #${order.id}",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Gap(12),
        Chip(
          label: Text(order.status.toUpperCase()),
          backgroundColor: _getStatusColor(order.status),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  /// Price, Payment Method, Payment Status
  Widget _buildOrderDetails(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.money, "Total Price",
            order.totalPrice.formatPrice.addRsPrefix),
        _infoRow(Icons.payment, "Payment", order.paymentMethod ?? "N/A"),
        Chip(
          label: Text(order.paymentStatus.toUpperCase()),
          backgroundColor: _getPaymentStatusColor(order.paymentStatus),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  /// Shipping Address & Created Date
  Widget _buildOrderFooter(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.location_on, "Shipping Address",
            order.shippingAddress?.fullAddress ?? "Not provided"),
        _infoRow(Icons.calendar_today, "Ordered On", order.createdAt),
      ],
    );
  }

  /// Generic Row with Icon
  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const Gap(8),
          Text("$title: ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  /// Status Color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Payment Status Color
  Color _getPaymentStatusColor(String paymentStatus) {
    switch (paymentStatus.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "unpaid":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
