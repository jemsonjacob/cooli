import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/profile/view_model/profile_view_model.dart';
import 'package:cooli/features/auth/view/login_view.dart';
import 'package:cooli/utils/cooli_theme.dart';

class ProfileView extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
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
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, vm, child) {
            final user = vm.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              child: Column(
                children: [
                  // User Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: CooliShadows.card,
                      border: Border.all(color: CooliColors.border.withValues(alpha: 0.8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: CooliColors.primaryGradient,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'John Doe',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: CooliColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user?.phoneNumber ?? '+91 98765 43210',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: CooliColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: CooliColors.primary, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Menu Items Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: CooliShadows.card,
                      border: Border.all(color: CooliColors.border.withValues(alpha: 0.8)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.inventory_2_outlined, 'My Orders', CooliColors.ecommerceOrange),
                        _buildDivider(),
                        _buildMenuItem(Icons.local_shipping_outlined, 'My Shipments', CooliColors.primary),
                        _buildDivider(),
                        _buildMenuItem(Icons.directions_car_outlined, 'My Rides', CooliColors.rideBlue),
                        _buildDivider(),
                        _buildMenuItem(Icons.build_outlined, 'My Bookings', const Color(0xFF0D9488)),
                        _buildDivider(),
                        _buildMenuItem(Icons.location_on_outlined, 'Addresses', Colors.purple),
                        _buildDivider(),
                        _buildMenuItem(Icons.credit_card_outlined, 'Payment Methods', Colors.indigo),
                        _buildDivider(),
                        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Wallet', Colors.green),
                        _buildDivider(),
                        _buildMenuItem(Icons.notifications_none_rounded, 'Notifications', Colors.amber.shade800),
                        _buildDivider(),
                        _buildMenuItem(Icons.help_outline_rounded, 'Help & Support', Colors.blueGrey),
                        _buildDivider(),
                        _buildMenuItem(Icons.settings_outlined, 'Settings', Colors.grey.shade700),
                        _buildDivider(),
                        _buildMenuItem(
                          Icons.logout_rounded,
                          'Logout',
                          CooliColors.danger,
                          isDanger: true,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginView.routeName,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Color iconColor, {
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 13.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 21),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isDanger ? FontWeight.w700 : FontWeight.w600,
                    color: isDanger ? CooliColors.danger : CooliColors.textDark,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDanger ? CooliColors.danger : CooliColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 52, endIndent: 16, color: CooliColors.borderLight);
  }
}
