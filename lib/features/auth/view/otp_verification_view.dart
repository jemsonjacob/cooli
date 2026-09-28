import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/auth/view_model/auth_view_model.dart';
import 'package:cooli/features/dashboard/view/main_navigation_view.dart';

class OtpVerificationView extends StatefulWidget {
  static const String routeName = '/otp-verification';
  final String? phoneNumber;

  const OtpVerificationView({super.key, this.phoneNumber});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView>
    with TickerProviderStateMixin {
  late AuthViewModel _viewModel;
  static const int _otpLength = 4;

  late AnimationController _illustrationController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    _startResendTimer();

    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _illustrationController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });

    for (final fn in _focusNodes) {
      fn.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        if (mounted) {
          setState(() {
            _resendSeconds--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _illustrationController.dispose();
    _fadeController.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  void _handleVerify() async {
    final otp = _getOtp();
    if (otp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter all 4 digits of the OTP code'),
          backgroundColor: const Color(0xFF4338CA),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final success = await _viewModel.verifyOtp(
      widget.phoneNumber ?? '+91 98765 43210',
      otp,
    );
    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavigationView.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneDisplay = widget.phoneNumber ??
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        '+91 98765 43210';

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          // White at top → purple at bottom (full screen)
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFAF9FF),
                Color(0xFFFAF9FF),
                Color(0xFFEDE8FF),
                Color(0xFFDDD6FE),
                Color(0xFFC4B5FD),
              ],
              stops: [0.0, 0.58, 0.72, 0.86, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Wave lines drawn on top of the gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: CustomPaint(
                  painter: _OtpWavePainter(),
                ),
              ),

            SafeArea(
              child: Consumer<AuthViewModel>(
                builder: (context, vm, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 14),

                          // Back Button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Illustration – plain image, no blob behind it
                          AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, _floatAnimation.value),
                              child: child,
                            ),
                            child: Image.asset(
                              'assets/images/cooli_otp_shield.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const _OtpPhoneIllustration(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Title
                          const Text(
                            'Verify Your Number',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Subtitle line 1
                          const Text(
                            "We've sent a 4 digit code to",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phoneDisplay,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4338CA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // 4 OTP boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_otpLength, (index) {
                              final isFilled =
                                  _controllers[index].text.isNotEmpty;
                              final isFocused = _focusNodes[index].hasFocus;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 60,
                                height: 64,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isFocused
                                        ? const Color(0xFF4338CA)
                                        : isFilled
                                            ? const Color(0xFF818CF8)
                                            : const Color(0xFFE2E8F0),
                                    width: isFocused ? 2.0 : 1.5,
                                  ),
                                  boxShadow: isFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF4338CA)
                                                .withValues(alpha: 0.18),
                                            blurRadius: 14,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.04),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                ),
                                child: Center(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                        filled: false,
                                        fillColor: Colors.transparent,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      maxLength: 1,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        height: 1.0,
                                      ),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: false,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        setState(() {});
                                        if (val.isNotEmpty) {
                                          if (index < _otpLength - 1) {
                                            _focusNodes[index + 1]
                                                .requestFocus();
                                          } else {
                                            _focusNodes[index].unfocus();
                                            if (_getOtp().length ==
                                                _otpLength) {
                                              _handleVerify();
                                            }
                                          }
                                        } else if (val.isEmpty && index > 0) {
                                          _controllers[index].clear();
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 28),

                          // Resend timer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _resendSeconds > 0
                                    ? 'Resend code in '
                                    : "Didn't receive the code? ",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              if (_resendSeconds > 0)
                                Text(
                                  '00:${_resendSeconds.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4338CA),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: _startResendTimer,
                                  child: const Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4338CA),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Verify button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4338CA), Color(0xFF3B82F6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4338CA)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(32),
                                onTap: vm.isLoading ? null : _handleVerify,
                                child: Center(
                                  child: vm.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              'Verify',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),        // closes Container
      ),        // closes Scaffold
    );
  }
}

// Wave background painter – stays tight at the bottom
class _OtpWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()
      ..color = const Color(0xFFC4B5FD).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final paintFront = Paint()
      ..color = const Color(0xFFDDD6FE).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Back wave – starts at 45% of painter height
    final pathBack = Path();
    pathBack.moveTo(0, size.height * 0.45);
    pathBack.cubicTo(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.6,
      size.height * 0.65,
      size.width,
      size.height * 0.10,
    );
    pathBack.lineTo(size.width, size.height);
    pathBack.lineTo(0, size.height);
    pathBack.close();
    canvas.drawPath(pathBack, paintBack);

    // Front wave – starts at 65%
    final pathFront = Path();
    pathFront.moveTo(0, size.height * 0.65);
    pathFront.cubicTo(
      size.width * 0.3,
      size.height * 0.40,
      size.width * 0.65,
      size.height * 0.80,
      size.width,
      size.height * 0.40,
    );
    pathFront.lineTo(size.width, size.height);
    pathFront.lineTo(0, size.height);
    pathFront.close();
    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Fallback illustration widget (drawn in Flutter)
class _OtpPhoneIllustration extends StatelessWidget {
  const _OtpPhoneIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195,
      height: 195,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone body
          Positioned(
            top: 8,
            left: 40,
            child: Container(
              width: 100,
              height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4338CA).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          // Phone screen
          Positioned(
            top: 22,
            left: 48,
            child: Container(
              width: 84,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFEDE9FE),
              ),
              child: const Center(
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 44,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
          ),
          // Notch
          Positioned(
            top: 16,
            left: 74,
            child: Container(
              width: 32,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF4338CA),
              ),
            ),
          ),
          // Side shield
          Positioned(
            bottom: 8,
            right: 12,
            child: Container(
              width: 52,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4338CA).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          // Decorative dots
          Positioned(
            top: 28,
            left: 12,
            child: _OtpDot(color: const Color(0xFFA5B4FC)),
          ),
          Positioned(
            top: 10,
            right: 26,
            child: _OtpDot(color: const Color(0xFFC4B5FD), size: 7),
          ),
          Positioned(
            bottom: 46,
            left: 14,
            child: _OtpDot(color: const Color(0xFF818CF8), size: 6),
          ),
        ],
      ),
    );
  }
}

class _OtpDot extends StatelessWidget {
  final Color color;
  final double size;
  const _OtpDot({required this.color, this.size = 9});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
