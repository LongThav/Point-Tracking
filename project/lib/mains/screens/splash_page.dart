import 'package:flutter/material.dart';
// import '../../feature_auths/services/splash_service.dart';
import '../constants/logo.dart';
import '../services/splash_service.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashService splashService = SplashService();

  @override
  void initState() {
    splashService.checkAuthentication(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: _buildBody,
      bottomNavigationBar: _buildVersion,
    );
  }

  get _buildBody {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 259,
              height: 127,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(Logo.logo),
                fit: BoxFit.fill,
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'PO Management System',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  get _buildVersion {
    return const Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 38),
        child: SizedBox(
          child: Text(
            'Version 1.0',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
