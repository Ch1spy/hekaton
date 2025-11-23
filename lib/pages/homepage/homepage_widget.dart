import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage_model.dart';
export 'homepage_model.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({super.key});

  static String routeName = 'homepage';
  static String routePath = '/homepage';

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  late HomepageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepageModel());
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
        backgroundColor: const Color(0xFFF5F5F0),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WELCOME SECTION
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome back',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF6B6B6B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ime',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // SCAN CARD
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFE8E8E8),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sceneraj svoje račune',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'track your progress and stay motivated',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF6B6B6B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FFButtonWidget(
                            onPressed: () async {
                              final selectedMedia = await selectMedia(
                                imageQuality: 70,
                                multiImage: false,
                              );
                              if (selectedMedia != null &&
                                  selectedMedia.every((m) =>
                                      validateFileFormat(m.storagePath, context))) {
                                safeSetState(() => _model.isDataUploading_uploadData3sp = true);
                                var selectedUploadedFiles = <FFUploadedFile>[];

                                try {
                                  selectedUploadedFiles = selectedMedia
                                      .map((m) => FFUploadedFile(
                                            name: m.storagePath.split('/').last,
                                            bytes: m.bytes,
                                            height: m.dimensions?.height,
                                            width: m.dimensions?.width,
                                            blurHash: m.blurHash,
                                            originalFilename: m.originalFilename,
                                          ))
                                      .toList();
                                } finally {
                                  _model.isDataUploading_uploadData3sp = false;
                                }
                                if (selectedUploadedFiles.length == selectedMedia.length) {
                                  safeSetState(() {
                                    _model.uploadedLocalFile_uploadData3sp = selectedUploadedFiles.first;
                                  });
                                } else {
                                  safeSetState(() {});
                                  return;
                                }
                              }

                              context.pushNamed(
                                RazporedstroskovWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                  ),
                                },
                              );
                            },
                            text: 'scan',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 48.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: const Color(0xFF2D2D2D),
                              textStyle: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // QUICK ACTIONS HEADER
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'quick actions',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      Text(
                        'see all',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8FD9C3),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // QUICK ACTIONS GRID
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      // STATISTIKA CARD
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            StatsWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                              ),
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '📊',
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'statistika',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D2D2D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // EDUCATION CARD
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            EduWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                              ),
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '📚',
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'education',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D2D2D),
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
                
                // RECENT ACTIVITY HEADER
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'recent activity',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      Text(
                        'view all',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8FD9C3),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // RECENT ACTIVITY LIST
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      _buildActivityItem(
                        '✓',
                        'prišparal ta mesec po planu',
                        'great job! 🎉',
                        const Color(0xFF8FD9C3),
                      ),
                      _buildActivityItem(
                        '💧',
                        'manj zapravil na pijačkah',
                        'keep it up! 💪',
                        const Color(0xFF2D2D2D),
                      ),
                      _buildActivityItem(
                        '🍽️',
                        'manj jedel zunaj',
                        'saving money! 💰',
                        const Color(0xFF6B6B6B),
                      ),
                    ],
                  ),
                ),
              ]
                  .divide(const SizedBox(height: 24.0))
                  .addToStart(const SizedBox(height: 20.0))
                  .addToEnd(const SizedBox(height: 20.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String emoji, String title, String subtitle, Color iconBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w400,
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