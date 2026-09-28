import 'package:cooli/features/splash/model/splash_model.dart';

class SplashRepo {
  Future<SplashData> getSplashData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const SplashData(
      appName: 'Cooli',
      tagline: 'Your Everyday Logistics Partner',
      subTagline: 'Faster • Safer • Smarter',
    );
  }
}
