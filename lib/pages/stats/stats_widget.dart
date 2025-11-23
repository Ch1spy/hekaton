import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'stats_model.dart';
export 'stats_model.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  static String routeName = 'stats';
  static String routePath = '/stats';

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  late StatsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'hrana & pijača',
      'amount': '420€',
      'percentage': '+12%',
      'icon': '🍽️',
      'color': Color(0xFF8FD9C3),
      'isPositive': false,
    },
    {
      'name': 'nakupi',
      'amount': '680€',
      'percentage': '-5%',
      'icon': '🛍️',
      'color': Color(0xFFFFB3BC),
      'isPositive': true,
    },
    {
      'name': 'transport',
      'amount': '240€',
      'percentage': '+8%',
      'icon': '🚗',
      'color': Color(0xFFCAE9FF),
      'isPositive': false,
    },
    {
      'name': 'zabava',
      'amount': '180€',
      'percentage': '+3%',
      'icon': '🎬',
      'color': Color(0xFFFFC9D0),
      'isPositive': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatsModel());
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
            'statistika',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16.0, 0),
              child: IconButton(
                icon: const Icon(
                  Icons.filter_list,
                  color: Color(0xFF2D2D2D),
                  size: 24,
                ),
                onPressed: () {
                  // Filter action
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER SECTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'pregled stroškov',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'track your spending habits',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF6B6B6B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // TOTAL SPENDING CARD
                  Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'skupaj zapravil',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF6B6B6B),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>('ta mesec'),
                                options: const ['ta mesec', 'prejšni mesec', 'zadnjih 6 mesecev'],
                                onChanged: (val) => setState(() => _model.dropDownValue = val),
                                width: 140.0,
                                height: 36.0,
                                textStyle: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF2D2D2D),
                                  fontWeight: FontWeight.w500,
                                ),
                                hintText: 'obdobje',
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF6B6B6B),
                                  size: 18.0,
                                ),
                                fillColor: const Color(0xFFF5F5F0),
                                elevation: 0.0,
                                borderColor: const Color(0xFFE8E8E8),
                                borderWidth: 1.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '1,520€',
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              color: const Color(0xFF2D2D2D),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB3BC).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+8% od prejšnjega meseca',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF2D2D2D),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CATEGORIES HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'kje si zapravljal',
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

                  const SizedBox(height: 16),

                  // CATEGORIES GRID
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.85,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(
                        category['name'],
                        category['amount'],
                        category['percentage'],
                        category['icon'],
                        category['color'],
                        category['isPositive'],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // INSIGHTS SECTION
                  Text(
                    'insights',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildInsightCard(
                    '💡',
                    'največ zapravil na nakupih',
                    'poskusi zmanjšati stroške za 15% naslednji mesec',
                  ),

                  const SizedBox(height: 12),

                  _buildInsightCard(
                    '🎯',
                    'dobro napredovanje',
                    'tvoji stroški za transport so se zmanjšali za 8%',
                  ),

                  const SizedBox(height: 12),

                  _buildInsightCard(
                    '📊',
                    'spending pattern',
                    'največ zapraviš med vikendi',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String name,
    String amount,
    String percentage,
    String icon,
    Color color,
    bool isPositive,
  ) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? const Color(0xFF8FD9C3).withOpacity(0.2)
                        : const Color(0xFFFFB3BC).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    percentage,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF2D2D2D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String emoji, String title, String description) {
    return Container(
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
                color: const Color(0xFF8FD9C3).withOpacity(0.15),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
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
    );
  }
}