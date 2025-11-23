import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'skupinednd_model.dart';
export 'skupinednd_model.dart';

class SkupinedndWidget extends StatefulWidget {
  const SkupinedndWidget({super.key});

  static String routeName = 'skupinednd';
  static String routePath = '/skupinednd';

  @override
  State<SkupinedndWidget> createState() => _SkupinedndWidgetState();
}

class _SkupinedndWidgetState extends State<SkupinedndWidget> {
  late SkupinedndModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample group expenses
  List<Map<String, dynamic>> groupItems = [
    {'name': 'pizza večerja', 'totalPrice': '28.00€', 'myShare': '7.00€', 'group': '1 cimr'},
    {'name': 'netflix', 'totalPrice': '12.99€', 'myShare': '6.50€', 'group': '2 cimr'},
    {'name': 'airbnb', 'totalPrice': '150.00€', 'myShare': '50.00€', 'group': '3 cimr'},
    {'name': 'gorivo roadtrip', 'totalPrice': '80.00€', 'myShare': '20.00€', 'group': '4 cimr'},
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SkupinedndModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _deleteItem(int index) {
    setState(() {
      groupItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'strošek izbrisan',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        duration: const Duration(seconds: 2),
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
        backgroundColor: const Color(0xFFF5F5F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'cimri',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D2D2D),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GROUPS HEADER
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'skupine',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    Text(
                      'uredi',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8FD9C3),
                      ),
                    ),
                  ],
                ),
              ),

              // GROUPS GRID
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.5,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    _buildGroupCard('👤', '1 cimr'),
                    _buildGroupCard('👥', '2 cimr'),
                    _buildGroupCard('👨‍👩‍👦', '3 cimr'),
                    _buildGroupCard('👨‍👩‍👧‍👦', '4 cimr'),
                  ],
                ),
              ),

              // SHARED EXPENSES HEADER
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'deljeni stroški',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    Text(
                      '${groupItems.length} stroškov',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ],
                ),
              ),

              // SWIPEABLE GROUP ITEMS LIST
              Expanded(
                child: groupItems.isEmpty
                    ? Center(
                        child: Text(
                          'ni deljenih stroškov',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                        itemCount: groupItems.length,
                        itemBuilder: (context, index) {
                          return _buildSwipeableGroupItem(
                            groupItems[index]['name'],
                            groupItems[index]['totalPrice'],
                            groupItems[index]['myShare'],
                            groupItems[index]['group'],
                            index,
                          );
                        },
                      ),
              ),
            ]
                .divide(const SizedBox(height: 20.0))
                .addToStart(const SizedBox(height: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(String emoji, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableGroupItem(
    String name,
    String totalPrice,
    String myShare,
    String group,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key('$name-$index'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteItem(index);
        },
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
        child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    Text(
                      totalPrice,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FD9C3).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'moj delež: $myShare',
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
      ),
    );
  }
}