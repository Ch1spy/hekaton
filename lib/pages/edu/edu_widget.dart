import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edu_model.dart';
export 'edu_model.dart';

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

  // Sample educational content
  final List<Map<String, String>> topics = [
    {
      'emoji': '💰',
      'title': 'bitcoin & crypto',
      'description': 'osnove kriptovalut',
    },
    {
      'emoji': '🎯',
      'title': 'davki & finance',
      'description': 'KVIZ',
    },
    {
      'emoji': '📈',
      'title': 'investiranje',
      'description': 'začni investirati',
    },
    {
      'emoji': '💳',
      'title': 'varčevanje',
      'description': 'money saving tips',
    },
  ];

  final List<Map<String, String>> news = [
    {
      'title': 'kako investirati v delnice za začetnike',
      'date': '23 nov 2024',
    },
    {
      'title': 'šparat ali ne šparat - smart budgeting',
      'date': '22 nov 2024',
    },
    {
      'title': 'razumevanje davčnih olajšav',
      'date': '21 nov 2024',
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EduModel());
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
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'education',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D2D2D),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'več zate',
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

                const SizedBox(height: 24),

                // FEATURED CARD
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FD9C3),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFE8E8E8),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊',
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'kaj je dohodnina?',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'veš zakaj konec leta plačuješ dohodnino?',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FFButtonWidget(
                            onPressed: () async {
                              // Navigate to article
                            },
                            text: 'preberi več',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 44.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Colors.white,
                              textStyle: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D2D2D),
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

                const SizedBox(height: 24),

                // TOPICS HEADER
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'teme',
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

                const SizedBox(height: 16),

                // TOPICS GRID
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.1,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (index == 1) {
                            // Quiz card
                            context.pushNamed(
                              KvizeduWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          }
                        },
                        child: _buildTopicCard(
                          topic['emoji']!,
                          topic['title']!,
                          topic['description']!,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // NEWS HEADER
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'najnovejše novice',
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

                const SizedBox(height: 16),

                // NEWS LIST
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final article = news[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildNewsCard(
                          article['title']!,
                          article['date']!,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(String emoji, String title, String description) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF6B6B6B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(String title, String date) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1.0,
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
                color: const Color(0xFF8FD9C3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                child: Text(
                  '📰',
                  style: TextStyle(fontSize: 20),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF6B6B6B),
            ),
          ],
        ),
      ),
    );
  }
}