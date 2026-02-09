import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:service_provider/core/routing/routing_manager.dart';
import 'package:service_provider/features/auth/data_layer/services/auth_service.dart';

class OtpController extends GetxController {
  RxInt seconds = 60.obs;
  final AuthService _authService = AuthService();
  RxBool isLoading = false.obs;
  RxBool canResend = false.obs;
  bool isFromRegester = true;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  Future<void> otp(String phone, String otp, int forVerifiyAccount) async {
    try {
      isLoading.value = true;
      bool success = await _authService.otp(
        phone: phone,
        code: otp,
        forVerifiyAccount: forVerifiyAccount,
      );
      if (success) {
        isLoading.value = false;
        Get.snackbar(
          'Login successfuly'.tr(),
          'Welcome!'.tr(),
          // ignore: deprecated_member_use
          backgroundColor: Color(0xFF44C838).withOpacity(0.5),
        );
        Get.offNamed(RoutingManager.superHome);
      } else {}
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Login Failed'.tr(),
        e.toString().tr(),
        // ignore: deprecated_member_use
        backgroundColor: Color(0XFFCF362E).withOpacity(0.5),
      );
    }
  }

  void startTimer() {
    canResend.value = false;
    seconds.value = 60;

    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds.value == 0) {
        timer.cancel();
        canResend.value = true;
      } else {
        seconds.value--;
      }
    });
  }

  String get timeText {
    final s = seconds.value;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  void resendCode(String phoneNumber) {
    if (!canResend.value) return;

    // ignore: unused_element
    Future<void> otp(String phone, String otp, forVerifiyAccount) async {
      try {
        isLoading.value = true;
        bool success = await _authService.otp(
          phone: phone,
          code: otp,
          forVerifiyAccount: forVerifiyAccount,
        );
        if (success) {
          isLoading.value = false;
          Get.snackbar(
            'Login successfuly'.tr(),
            'Welcome!'.tr(),
            // ignore: deprecated_member_use
            backgroundColor: Color(0xFF44C838).withOpacity(0.5),
          );
          Get.offNamed(RoutingManager.superHome);
        } else {
          // log('Failed');
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'Login Failed'.tr(),
          e.toString().tr(),
          // ignore: deprecated_member_use
          backgroundColor: Color(0XFFCF362E).withOpacity(0.5),
        );
      }
    }

    startTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
