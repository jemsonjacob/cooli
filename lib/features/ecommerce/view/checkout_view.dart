import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ecommerce/view_model/ecommerce_view_model.dart';
import 'package:cooli/features/ecommerce/view/order_confirmed_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class CheckoutView extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late EcommerceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepItem(1, 'Address', true),
        _buildStepLine(true),
        _buildStepItem(2, 'Delivery', true),
        _buildStepLine(true),
        _buildStepItem(3, 'Payment', false, isActive: true),
        _buildStepLine(false),
        _buildStepItem(4, 'Review', false),
      ],
    );
  }

  Widget _buildStepItem(int step, String label, bool isDone, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive ? CooliColors.primary : CooliColors.surfaceAlt,
            border: Border.all(
              color: isDone || isActive ? CooliColors.primary : CooliColors.border,
            ),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : CooliColors.textMuted,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive || isDone ? FontWeight.w600 : FontWeight.w500,
            color: isActive || isDone ? CooliColors.primary : CooliColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isDone) {
    return Container(
      width: 28,
      height: 2,
      margin: const EdgeInsets.only(bottom: 14, left: 4, right: 4),
      color: isDone ? CooliColors.primary : CooliColors.border,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: CooliColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: CooliColors.textDark, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<EcommerceViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Steps Indicator
                        _buildStepIndicator(),

                        const SizedBox(height: 24),

                        // Delivery Address Card
                        const Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: CooliColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: CooliShadows.card,
                            border: Border.all(color: CooliColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CooliColors.primarySoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: CooliColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: CooliColors.textDark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Kochi, Kerala',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: CooliColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    color: CooliColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Payment Method
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: CooliColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // UPI Option
                        _buildPaymentTile(
                          title: 'UPI',
                          subtitle: 'Google Pay, PhonePe, Paytm',
                          icon: Icons.account_balance_wallet_rounded,
                          value: 'UPI',
                          selectedValue: vm.selectedPaymentMethod,
                          onChanged: vm.setPaymentMethod,
                        ),
                        const SizedBox(height: 10),

                        // Card Option
                        _buildPaymentTile(
                          title: 'Card',
                          subtitle: 'Credit / Debit Card',
                          icon: Icons.credit_card_rounded,
                          value: 'Card',
                          selectedValue: vm.selectedPaymentMethod,
                          onChanged: vm.setPaymentMethod,
                        ),
                        const SizedBox(height: 10),

                        // Cash on Delivery Option
                        _buildPaymentTile(
                          title: 'Cash on Delivery',
                          subtitle: 'Pay when items arrive',
                          icon: Icons.payments_rounded,
                          value: 'COD',
                          selectedValue: vm.selectedPaymentMethod,
                          onChanged: vm.setPaymentMethod,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Checkout Action Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: CooliShadows.elevated,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 12, color: CooliColors.textMuted),
                          ),
                          Text(
                            '₹${vm.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: CooliColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CooliButton(
                          text: 'Place Order',
                          onTap: () {
                            Navigator.pushNamed(context, OrderConfirmedView.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? CooliColors.primary : CooliColors.border,
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected ? CooliShadows.button.sublist(0, 1) : CooliShadows.soft,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? CooliColors.primarySoft : CooliColors.surfaceAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? CooliColors.primary : CooliColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? CooliColors.primaryDark : CooliColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: CooliColors.textMuted),
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            Radio<String>(
              value: value,
              // ignore: deprecated_member_use
              groupValue: selectedValue,
              activeColor: CooliColors.primary,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
