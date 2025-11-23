import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'razporedstroskov_model.dart';
import 'dart:convert';
export 'razporedstroskov_model.dart';

class RazporedstroskovWidget extends StatefulWidget {
  const RazporedstroskovWidget({super.key});

  static String routeName = 'razporedstroskov';
  static String routePath = '/razporedstroskov';

  @override
  State<RazporedstroskovWidget> createState() => _RazporedstroskovWidgetState();
}

class _RazporedstroskovWidgetState extends State<RazporedstroskovWidget> {
  late RazporedstroskovModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> itemsToSwipe = [];
  List<dynamic> allOriginalItems = [];
  bool _dataLoaded = false;
  bool _showSummary = false;

  final Map<String, dynamic> myUser = {'id': 'user_1', 'name': 'Dmitri'}; 
  final Map<String, dynamic> jostUser = {'id': 'user_2', 'name': 'Jošt'};

  List<dynamic> myItems = [];
  List<dynamic> jostItems = [];
  List<Map<String, dynamic>> finalAssignments = [];

  final String _splitApiUrl = 'https://app.brglez.net/split/calculate-debt';

  final Color _bgDark = const Color(0xFF121212);
  final Color _cardDark = const Color(0xFF1E1E1E);
  final Color _textWhite = const Color(0xFFEDEDED);
  final Color _textGrey = const Color(0xFFA0A0A0);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RazporedstroskovModel());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_dataLoaded) {
      try {
        final args = ModalRoute.of(context)?.settings.arguments;
        List<dynamic> foundItems = [];

        if (args is Map<String, dynamic>) {
          if (args.containsKey('items')) {
            foundItems = args['items'] ?? [];
          }
        }

        if (foundItems.isNotEmpty) {
          setState(() {
            itemsToSwipe = List.from(foundItems);
            allOriginalItems = List.from(foundItems);
            _dataLoaded = true;
          });
        } else {
          setState(() => _dataLoaded = true);
        }
      } catch (e) {
        setState(() => _dataLoaded = true);
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _calculateDebt() async {
    double jostTotal = jostItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0.0));
    
    final payload = {
      "payer_id": myUser['id'],
      "users": [myUser, jostUser],
      "items": allOriginalItems,
      "assignments": finalAssignments
    };

    print("Payload for API:\n${jsonEncode(payload)}");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 10,
        backgroundColor: _cardDark,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 40),
              ),
              SizedBox(height: 20),
              Text(
                "Uspešno razporejeno!",
                textAlign: TextAlign.center,
                style: GoogleFonts.interTight(fontSize: 20, fontWeight: FontWeight.bold, color: _textWhite),
              ),
              SizedBox(height: 10),
              Text(
                "Glede na to, da si ti plačal cel račun, ti mora Jošt vrniti:",
                textAlign: TextAlign.center,
                style: TextStyle(color: _textGrey, fontSize: 14),
              ),
              SizedBox(height: 24),
              
              Text(
                "€${jostTotal.toStringAsFixed(2)}",
                style: GoogleFonts.interTight(
                  fontSize: 42, 
                  fontWeight: FontWeight.w800, 
                  color: Colors.greenAccent
                ),
              ),
              
              SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Zaključi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
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
        backgroundColor: _bgDark,
        appBar: AppBar(
          backgroundColor: _bgDark,
          automaticallyImplyLeading: false,
          title: Text(
            _showSummary ? 'Povzetek' : 'Razporedi Stroške', 
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
              color: _textWhite,
              fontSize: 22
            )
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: _textWhite),
            )
          ],
          centerTitle: false,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: Colors.white.withOpacity(0.1), height: 1),
          ),
        ),
        body: SafeArea(
          top: true,
          child: !_dataLoaded 
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : _showSummary 
                ? _buildSummaryView() 
                : _buildSwipeView(),
        ),
      ),
    );
  }

  Widget _buildSwipeView() {
    if (itemsToSwipe.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _showSummary = true);
      });
      return Container();
    }

    final currentItem = itemsToSwipe[0];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1))
                ),
                child: Text(
                  "Še ${itemsToSwipe.length} artiklov",
                  style: TextStyle(color: _textGrey, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Dismissible(
              key: Key("${currentItem['id']}_${itemsToSwipe.length}"),
              background: _buildSwipeBackground(Alignment.centerLeft, Colors.green.shade900, Icons.person, "Moji"),
              secondaryBackground: _buildSwipeBackground(Alignment.centerRight, Colors.red.shade900, Icons.face, "Jošt"),
              
              onDismissed: (direction) {
                final swipedItem = itemsToSwipe[0];
                setState(() {
                  itemsToSwipe.removeAt(0);
                  if (direction == DismissDirection.startToEnd) {
                    myItems.add(swipedItem);
                    finalAssignments.add({"item_id": swipedItem['id'], "user_id": myUser['id']});
                  } else {
                    jostItems.add(swipedItem);
                    finalAssignments.add({"item_id": swipedItem['id'], "user_id": jostUser['id']});
                  }
                });
              },
              child: _buildCard(currentItem),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSummaryView() {
    double myTotal = myItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0.0));
    double jostTotal = jostItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0.0));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ME CARD
                Expanded(
                  child: _buildSummaryCard(
                    title: "Moj seznam",
                    color: Colors.greenAccent,
                    items: myItems,
                    total: myTotal,
                  ),
                ),
                
                SizedBox(width: 16),
                
                Expanded(
                  child: _buildSummaryCard(
                    title: "Joštov seznam",
                    color: Colors.redAccent,
                    items: jostItems,
                    total: jostTotal,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, 24, 24, 34),
          decoration: BoxDecoration(
            color: _cardDark,
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.5), offset: Offset(0, -5))],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Skupaj dolg:", style: TextStyle(color: _textGrey, fontSize: 16)),
                  Text("€${jostTotal.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textWhite)),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateDebt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    "Potrdi Izračun",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title, 
    required Color color, 
    required List<dynamic> items, 
    required double total
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.2), radius: 6, child: CircleAvatar(backgroundColor: color, radius: 3)),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _textWhite)),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
          SizedBox(height: 12),
          
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text("- Prazno -", style: TextStyle(color: Colors.grey[600], fontSize: 12))),
            ),
            
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(item['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: _textGrey))),
                SizedBox(width: 4),
                Text("€${item['price']}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textWhite)),
              ],
            ),
          )),
          
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Skupaj", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textGrey)),
                Text("€${total.toStringAsFixed(2)}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSwipeBackground(Alignment alignment, Color color, IconData icon, String label) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildCard(dynamic item) {
    return Container(
      width: 340,
      height: 500,
      decoration: BoxDecoration(
        color: _cardDark, // Dark Card
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.5), offset: Offset(0, 10))
        ],
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_rounded, size: 40, color: FlutterFlowTheme.of(context).primary),
            ),
            SizedBox(height: 30),
            Text(
              item['name']?.toString() ?? 'Neznano',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.interTight(fontSize: 24, fontWeight: FontWeight.w800, color: _textWhite),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "€${item['price']}",
                style: GoogleFonts.interTight(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.greenAccent),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.arrow_back, size: 16, color: Colors.redAccent),
                  SizedBox(width: 4),
                  Text("Jošt", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ]),
                Row(children: [
                  Text("Moji", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.greenAccent),
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }
}