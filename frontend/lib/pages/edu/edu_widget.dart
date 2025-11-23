import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edu_model.dart';
export 'edu_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math'; 

class EduWidget extends StatefulWidget {
  const EduWidget({super.key});

  static String routeName = 'edu';
  static String routePath = '/edu';

  @override
  State<EduWidget> createState() => _EduWidgetState();
}

class _EduWidgetState extends State<EduWidget> {
  late EduModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final String _supabaseUrl = 'https://hnzboevbvhmdaokxavws.supabase.co';
  final String _supabaseKey = 'sb_publishable_r_AMMyCDARSmTMddzE7JuA_vGb8vAGU'; 
  
  String _cardQuestion = 'Nalagam...';
  String _cardSubQuestion = '...';
  String _cardAnswer = ''; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EduModel());
    _initSupabaseAndFetch();
  }

  Future<void> _initSupabaseAndFetch() async {
    try {
      try {
        await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseKey);
      } catch (e) {
      }

      final supabase = Supabase.instance.client;

      final List<dynamic> response = await supabase
          .from('flashcards')
          .select(); 

      if (mounted) {
        if (response.isEmpty) {
          setState(() {
            _cardQuestion = 'Ni vprašanj';
            _cardSubQuestion = 'Baza je prazna';
            _isLoading = false;
          });
        } else {
          final randomIndex = Random().nextInt(response.length);
          final randomCard = response[randomIndex];

          setState(() {
            _cardQuestion = randomCard['question'] ?? 'No Question';
            _cardSubQuestion = randomCard['question1'] ?? 'No Sub-question'; 
            _cardAnswer = randomCard['answer'] ?? 'Ni podrobnega opisa.'; 
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching supabase data: $e');
      if (mounted) {
        setState(() {
          _cardQuestion = 'Napaka';
          _cardSubQuestion = 'Preveri internetno povezavo';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'več zate',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                          ),
                          Text(
                            'Dmitri', 
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 180.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primaryBackground,
                          Color(0xFFF95858)
                        ],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFF95858).withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _isLoading 
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              _cardQuestion, 
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 16.0),
                              child: _isLoading 
                              ? SizedBox() 
                              : Text(
                                _cardSubQuestion, 
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ),
                          ),
                          
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FaqDetailsWidget(
                                      question: _cardQuestion,
                                      answer: _cardAnswer,
                                    ),
                                  ),
                                );
                              },
                              text: 'preberi več',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.white,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                      color: Color(0xFFF95858),
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.85, 
                    ),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF5F0),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Color(0xFFFFE0D0),
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.orangeAccent,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '25', // Hardcoded Streak
                                textAlign: TextAlign.center,
                                style: GoogleFonts.interTight(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'dni zapored',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          context.pushNamed(
                            KvizeduWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.rightToLeft,
                              ),
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E1E), 
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.school_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Kviz',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.interTight(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Preveri znanje',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ]
                  .divide(SizedBox(height: 24.0))
                  .addToStart(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}

class FaqDetailsWidget extends StatelessWidget {
  final String question;
  final String answer;

  const FaqDetailsWidget({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
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
                    Color(0xFFF95858)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF95858).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "INFO",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  Text(
                    question,
                    style: GoogleFonts.interTight(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Answer Text
            Text(
              "Odgovor:",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 18,
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}