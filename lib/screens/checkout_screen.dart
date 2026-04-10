import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _selectedPaymentMethod = 'card';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _addressController.text = authProvider.user?.address ?? '';
    _phoneController.text = authProvider.user?.phone ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      final order = await orderProvider.placeOrder(
        items: cartProvider.items,
        totalAmount: cartProvider.grandTotal,
        deliveryAddress: _addressController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
        specialInstructions: _instructionsController.text.trim().isEmpty
            ? null
            : _instructionsController.text.trim(),
      );

      if (order != null && mounted) {
        cartProvider.clear();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.orderStatus,
          (route) => route.settings.name == AppRoutes.dashboard,
          arguments: order.id,
        );
      } else if (mounted && orderProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.error!),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _placeOrder,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliverySection(),
                  const SizedBox(height: 24),
                  _buildPaymentSection(),
                  const SizedBox(height: 24),
                  _buildOrderSummary(cartProvider),
                  const SizedBox(height: 24),
                  _buildSpecialInstructions(),
                  const SizedBox(height: 32),
                  _buildPlaceOrderButton(cartProvider),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.pastelBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Delivery Address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Full Address',
          hint: 'Enter your delivery address',
          controller: _addressController,
          prefixIcon: Icons.home_outlined,
          validator: Validators.validateAddress,
          maxLines: 2,
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Phone Number',
          hint: 'Enter your phone number',
          controller: _phoneController,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.validatePhone,
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.pastelGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.payment,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        _buildPaymentOption(
          'card',
          'Credit/Debit Card',
          Icons.credit_card,
          '**** **** **** 4242',
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'cash',
          'Cash on Delivery',
          Icons.money,
          'Pay when you receive',
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'wallet',
          'Digital Wallet',
          Icons.account_balance_wallet,
          'Apple Pay, Google Pay',
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.pastelYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppTheme.warningColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              ...cartProvider.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.menuItem.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
              const Divider(),
              _buildSummaryRow('Subtotal', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildSummaryRow('Delivery Fee', cartProvider.deliveryFee == 0 ? 'FREE' : '\$${cartProvider.deliveryFee.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildSummaryRow('Tax', '\$${cartProvider.tax.toStringAsFixed(2)}'),
              const Divider(height: 20),
              _buildSummaryRow(
                'Total',
                '\$${cartProvider.grandTotal.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.pastelPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.note_alt,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Special Instructions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Add a note (optional)',
          hint: 'E.g., Ring the doorbell twice, extra napkins...',
          controller: _instructionsController,
          maxLines: 3,
          prefixIcon: Icons.edit_note,
        ).animate().fadeIn(delay: 1000.ms),
      ],
    );
  }

  Widget _buildPlaceOrderButton(CartProvider cartProvider) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return CustomButton(
          text: 'Place Order - \$${cartProvider.grandTotal.toStringAsFixed(2)}',
          icon: Icons.check_circle,
          width: double.infinity,
          isLoading: orderProvider.isLoading,
          onPressed: _placeOrder,
        ).animate().fadeIn(delay: 1100.ms).scale();
      },
    );
  }
}