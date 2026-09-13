import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/registration_data.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import 'buyer_account_created_screen.dart';

class BuyerCreateAccountVerifyOtpScreen extends StatefulWidget {
  final RegistrationData data;

  const BuyerCreateAccountVerifyOtpScreen({
    super.key,
    required this.data,
  });

  @override
  State<BuyerCreateAccountVerifyOtpScreen> createState() =>
      _BuyerCreateAccountVerifyOtpScreenState();
}

class _BuyerCreateAccountVerifyOtpScreenState
    extends State<BuyerCreateAccountVerifyOtpScreen> {
  late final TextEditingController _phoneController;
  late final List<TextEditingController> _otpControllers;

  bool _isCodeSent = false;
  bool _isLoading = false;
  String _verificationId = '';
  int _secondsRemaining = 58;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.data.phoneNumber);
    _otpControllers = List.generate(6, (_) => TextEditingController());
    if (widget.data.phoneNumber.isNotEmpty) {
      _sendSmsCode();
    }
  }

  void _startTimer() {
    _secondsRemaining = 58;
    Future.delayed(const Duration(seconds: 1), _timerTick);
  }

  void _timerTick() {
    if (mounted && _secondsRemaining > 0) {
      setState(() => _secondsRemaining--);
      Future.delayed(const Duration(seconds: 1), _timerTick);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatPhoneNumber(String raw) {
    String cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.startsWith('+')) return cleaned;
    if (cleaned.startsWith('00')) return '+${cleaned.substring(2)}';
    if (cleaned.startsWith('03')) return '+92${cleaned.substring(1)}';
    if (cleaned.startsWith('3') && cleaned.length == 10) return '+92$cleaned';
    return cleaned.startsWith('+') ? cleaned : '+$cleaned';
  }

  void _sendSmsCode() async {
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty || rawPhone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid mobile number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phone = _formatPhoneNumber(rawPhone);
    _phoneController.text = phone;

    setState(() => _isLoading = true);

    await AuthService.instance.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verId, _) {
        if (!mounted) return;
        setState(() {
          _verificationId = verId;
          _isCodeSent = true;
          _isLoading = false;
        });
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to $phone'),
            backgroundColor: const Color(0xFF00A63E),
          ),
        );
      },
      onVerificationFailed: (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _isCodeSent = true;
        });
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.contains('swizzling') || error.contains('notification')
                  ? 'Simulator: APNs unavailable. Enter test code (123456 or 000000).'
                  : 'Verification failed: $error',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      },
      onVerificationCompleted: () {
        if (!mounted) return;
        _handleVerificationSuccess();
      },
    );
  }

  void _verifyOtpAndRegister() async {
    final enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP code.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final isValid = await AuthService.instance.verifySmsCode(
      verificationId: _verificationId,
      smsCode: enteredOtp,
    );

    if (isValid) {
      await _handleVerificationSuccess();
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code. Please enter the correct code or 000000.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleVerificationSuccess() async {
    widget.data.phoneNumber = _phoneController.text.trim();
    widget.data.phoneVerified = true;
    widget.data.twoFactorEnabled = true;

    // Register user profile on backend
    final result = await AuthService.instance.register(widget.data);

    if (result.isSuccess) {
      // Upload profile image if present
      if (widget.data.profilePhotoFile != null) {
        try {
          await ProfileService.instance
              .uploadProfilePhoto(widget.data.profilePhotoFile!);
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => BuyerAccountCreatedScreen(
            companyName: widget.data.companyName.isNotEmpty
                ? widget.data.companyName
                : 'Scrap Buyer',
            location: widget.data.city.isNotEmpty
                ? widget.data.city
                : 'Registered Office',
            email: widget.data.email,
            userId: result.user?.userId,
          ),
        ),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Registration failed. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Header with Back Button and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Text(
                    'Mobile Verification',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),

              // Synchronized Step Progress Indicator: Step 3 of 3 (100%)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step 3 of 3 · Mobile Verification (2FA)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    '100%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00A63E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Phone Icon inside Green Circle
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/phone_call.svg',
                    width: 44,
                    height: 44,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF00A63E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Verify Mobile Number',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Protect your scrap trades and account with two-factor mobile authentication (2FA).',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Mobile Number Input Field with Country Code
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '+92 300 1234567',
                  prefixIcon: const Icon(Icons.phone_iphone_outlined,
                      color: Color(0xFF00A63E), size: 20),
                  suffixIcon: TextButton(
                    onPressed: _isLoading ? null : _sendSmsCode,
                    child: Text(
                      _isCodeSent ? 'Resend' : 'Send Code',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00A63E),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00A63E)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_isCodeSent) ...[
                Text(
                  'Enter 6-Digit Code',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                // OTP 6 Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        controller: _otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF00A63E), width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Resend Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      _secondsRemaining > 0
                          ? 'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                          : 'Didn\'t get the code?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (_secondsRemaining == 0) ...[
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _sendSmsCode,
                        child: Text(
                          'Resend Now',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00A63E),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 28),

                // Complete Account Creation Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtpAndRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A63E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Verify & Complete Registration',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
