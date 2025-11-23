import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mojadnd_model.dart';
export 'mojadnd_model.dart';

class MojadndWidget extends StatefulWidget {
  const MojadndWidget({super.key});

  static String routeName = 'mojadnd';
  static String routePath = '/mojadnd';

  @override
  State<MojadndWidget> createState() => _MojadndWidgetState();
}

class _MojadndWidgetState extends State<MojadndWidget> {
  late MojadndModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data - later replace with real data
  List<Map<String, dynamic>> items = [
    {'name': 'mleko', 'price': '1.50€', 'category': 'groceries'},
    {'name': 'kruh', 'price': '2.20€', 'category': 'groceries'},
    {'name': 'bencin', 'price': '45.00€', 'category': 'bencin'},
    {'name': 'kava', 'price': '3.50€', 'category': 'osebno'},
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MojadndModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'izdelek izbrisan',
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
            'moji stroški',
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
              // CATEGORIES HEADER
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'kategorije',
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

              // CATEGORIES GRID
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
                    _buildCategoryCard('🛒', 'groceries'),
                    _buildCategoryCard('⛽', 'bencin'),
                    _buildCategoryCard('👤', 'osebno'),
                    _buildCategoryCard('📦', 'ostalo'),
                  ],
                ),
              ),

              // ITEMS HEADER
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'izdelki',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    Text(
                      '${items.length} izdelkov',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ],
                ),
              ),

              // SWIPEABLE ITEMS LIST
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'ni izdelkov',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _buildSwipeableItem(
                            items[index]['name'],
                            items[index]['price'],
                            items[index]['category'],
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

  Widget _buildCategoryCard(String emoji, String label) {
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

  Widget _buildSwipeableItem(String name, String price, String category, int index) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF6B6B6B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}