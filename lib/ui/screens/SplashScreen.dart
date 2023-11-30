import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/auth-utils.dart';
import '../widgets/screen-Background-images.dart';
import 'loginScreen.dart';
import 'main-bottom-navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) => {
    checkUserAuthState(),
    });
  }

  void checkUserAuthState() async{
    final bool result = await AuthUtils.checkLoginState();
    if(result){
      await AuthUtils.getAuthData();
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const MainBottomNavBar()), (
                route) => false);
      }
    } else{
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.scaleDown,
          width: 175,
        ),
      ),)
    );
  }
}
