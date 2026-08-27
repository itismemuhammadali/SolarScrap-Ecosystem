import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'buyer_account_created_screen.dart';

class BuyerCreateAccountVerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String companyName;
  final String location;

  const BuyerCreateAccountVerifyOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.companyName,
    required this.location,
  });

  @override
  State<BuyerCreateAccountVerifyOtpScreen> createState() =>
      _BuyerCreateAccountVerifyOtpScreenState();
}

class _BuyerCreateAccountVerifyOtpScreenState
    extends State<BuyerCreateAccountVerifyOtpScreen> {
  late List<TextEditingController> _otpControllers;
  int _secondsRemaining = 58;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getOtpValue() {
    return _otpControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Phone Icon in green circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/phone_call.svg',
                    width: 50,
                    height: 50,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF00A63E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Description with phone number
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Enter the 6-digit code sent to your mobile number\nending in ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF00A63E)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Resend in ${_secondsRemaining.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Verify Account Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF00A63E),
                      Color(0xFF007D2E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: _getOtpValue().length == 6
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BuyerAccountCreatedScreen(
                                companyName: widget.companyName,
                                location: widget.location,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Verify Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Resend/Help Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: 'Check your spam folder or try resending.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
