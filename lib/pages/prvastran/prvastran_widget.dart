import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/index.dart';
import 'prvastran_model.dart';
export 'prvastran_model.dart';

class PrvastranWidget extends StatefulWidget {
  const PrvastranWidget({super.key});

  static String routeName = 'prvastran';
  static String routePath = '/prvastran';

  @override
  State<PrvastranWidget> createState() => _PrvastranWidgetState();
}

class _PrvastranWidgetState extends State<PrvastranWidget> 
    with SingleTickerProviderStateMixin {
  late PrvastranModel _model;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrvastranModel());
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _animationController.forward();
    
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.pushReplacementNamed(
          HomepageWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: const Duration(milliseconds: 300),
            ),
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF5F5F0), // Unified background
        body: SafeArea(
          top: true,
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}