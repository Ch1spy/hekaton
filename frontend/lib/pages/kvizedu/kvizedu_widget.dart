import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kvizedu_model.dart';
export 'kvizedu_model.dart';

class KvizeduWidget extends StatefulWidget {
  const KvizeduWidget({super.key});

  static String routeName = 'kvizedu';
  static String routePath = '/kvizedu';

  @override
  State<KvizeduWidget> createState() => _KvizeduWidgetState();
}

class _KvizeduWidgetState extends State<KvizeduWidget> {
  late KvizeduModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  final int _correctOptionIndex = 1;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KvizeduModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleAnswer(int index) {
    if (_hasAnswered) return;

    setState(() {
      _selectedOptionIndex = index;
      _hasAnswered = true;
    });
  }

  Widget _buildOptionCard(int index, String text, String letter) {
    Color borderColor = Color(0xFFE2E8F0);
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (_hasAnswered) {
      if (index == _correctOptionIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        iconColor = Colors.green;
      } else if (index == _selectedOptionIndex && index != _correctOptionIndex) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        iconColor = Colors.red;
      } else {
        borderColor = Colors.transparent;
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade400;
      }
    } else {
      if (_selectedOptionIndex == index) {
        borderColor = FlutterFlowTheme.of(context).primary;
        bgColor = FlutterFlowTheme.of(context).primary.withOpacity(0.05);
      }
    }

    return InkWell(
      onTap: () => _handleAnswer(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            if (!_hasAnswered)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _hasAnswered && (index == _correctOptionIndex || index == _selectedOptionIndex)
                    ? Colors.white.withOpacity(0.5)
                    : Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: _hasAnswered && index != _correctOptionIndex && index != _selectedOptionIndex
                        ? Colors.grey.shade400
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (_hasAnswered && icon != null)
              Icon(icon, color: iconColor, size: 24),
          ],
        ),
      ),
    );
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false, 
          title: Text(
            'Kviz',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),

        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.2, // 1 out of 5
                          backgroundColor: Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "1/5",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primaryBackground,
                              Color(0xFF4B39EF)
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF4B39EF).withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "DAVKI",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Kaj so davki in zakaj jih plačujemo?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.interTight(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),

                      Text(
                        "Izberi pravilen odgovor:",
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),

                      Column(
                        children: [
                          _buildOptionCard(0, "Prostovoljni prispevki državi", "A"),
                          SizedBox(height: 12),
                          _buildOptionCard(1, "Obvezni prispevki za javne storitve", "B"),
                          SizedBox(height: 12),
                          _buildOptionCard(2, "Kazni za prekrške", "C"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (_hasAnswered)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Naslednje vprašanje...")),
                      );
                    },
                    text: 'Naslednje vprašanje',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56.0,
                      color: Colors.black,
                      textStyle: GoogleFonts.interTight(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}