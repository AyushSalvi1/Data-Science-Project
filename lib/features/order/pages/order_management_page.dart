// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';

import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/order/blocs/get_vendor_order_bloc/get_vendor_order_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:flutter_ecommerce/features/order/models/order_model.dart';
import 'package:go_router/go_router.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  @override
  void initState() {
    sl<GetVendorOrderBloc>().add(const GetVendorOrderEvent.get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Management"),
      ),
      body: BlocBuilder<GetVendorOrderBloc, GetVendorOrderState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (failure) => Center(child: Text(failure.toString())),
            loaded: (orders) => orders.isEmpty
                ? const Center(child: Text("No orders found"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(order: order);
                    },
                  ),
          );
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final OrderBloc orderBloc = sl<OrderBloc>();

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "pending":
      default:
        return Colors.orange;
    }
  }

  void _showActionSheet(BuildContext context, String newStatus) {
    final isAccept = newStatus == "accepted";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAccept ? Icons.check_circle : Icons.cancel,
                size: 40,
                color: isAccept ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to ${isAccept ? "accept" : "cancel"} this order?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => orderBloc.add(
                          OrderEvent.updateOrderStatus(
                              orderId: widget.order.id,
                              status: isAccept ? "confirmed" : "cancelled")),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAccept ? Colors.green : Colors.red,
                      ),
                      child: Text(
                        isAccept ? "Accept" : "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Order #${widget.order.id}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(
                    widget.order.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(widget.order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor:
                      _statusColor(widget.order.status).withAlpha(40),
                )
              ],
            ),
            const SizedBox(height: 8),

            /// Date
            Text(
              "Placed on: ${widget.order.createdAt.toString().split(' ')[0]}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 20),

            /// Shipping Address
            if (widget.order.shippingAddress != null) ...[
              Text("Shipping Address:",
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(widget.order.shippingAddress!.fullAddress,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),

            /// Items
            if (widget.order.orderItems?.isNotEmpty == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Items:", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  ...widget.order.orderItems!.take(2).map(
                        (item) =>
                            Text("• ${item.product.name} ×${item.quantity}"),
                      ),
                  if ((widget.order.orderItems?.length ?? 0) > 2)
                    Text(
                      "+${widget.order.orderItems!.length - 2} more",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),

            /// Accept / Cancel Buttons (only for pending)
            if (widget.order.status.toLowerCase() == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _showActionSheet(context, "accepted"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _showActionSheet(context, "cancelled"),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = widget.order.status.toLowerCase() == "pending";

    if (!isPending) return _buildCardContent(context);

    return BlocListener<OrderBloc, OrderState>(
      bloc: orderBloc,
      listener: (context, state) {
        state.whenOrNull(
          loading: () => AppProgressIndicator.show(context),
          failure: (failure) {
            context.pop();
            AppProgressIndicator.hide(context);
            AppToast.error(context, failure.toString());
          },
          loaded: (msg) {
            context.pop();

            AppProgressIndicator.hide(context);
            sl<GetVendorOrderBloc>().add(const GetVendorOrderEvent.get());
            AppToast.success(context, msg);
          },
        );
      },
      child: Dismissible(
        key: ValueKey(widget.order.id),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          color: Colors.green.withAlpha(255 ~/ 0.8),
          child: const Icon(Icons.check, color: Colors.white),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          color: Colors.red.withAlpha(255 ~/ 0.8),
          child: const Icon(Icons.close, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _showActionSheet(context, "accepted");
          } else {
            _showActionSheet(context, "cancelled");
          }
          return false;
        },
        child: _buildCardContent(context),
      ),
    );
  }
}
