import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/percent_indicator.dart'; // REMOVED: Caused error
import 'kvizedu_model.dart';
export 'kvizedu_model.dart';

// --- Global helper function placeholder (mimicking FlutterFlow) ---
// Note: In a real environment, this is provided by FlutterFlow's setup.
T createModel<T extends FlutterFlowModel>(BuildContext context, T Function() factory) => factory();

class KvizeduWidget extends StatefulWidget {
  const KvizeduWidget({super.key});

  static String routeName = 'kvizedu';
  static String routePath = '/kvizedu';

  @override
  State<KvizeduWidget> createState() => _KvizeduWidgetState();
}

class _KvizeduWidgetState extends State<KvizeduWidget> with TickerProviderStateMixin {
  // All state variables and methods must be INSIDE this class body
  late KvizeduModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  int currentCardIndex = 0;
  bool showAnswer = false;
  int correctAnswers = 0;
  
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  // Quiz questions (Slovenian tax data)
  final List<Map<String, dynamic>> quizCards = [
    {
      'question': 'Kaj so davki?',
      'options': [
        'Prostovoljni prispevki državi',
        'Obvezni prispevki za javne storitve',
        'Kazni za prekrške',
      ],
      'correctIndex': 1,
      'explanation': 'Davki so obvezni prispevki, ki jih plačujemo državi za financiranje javnih storitev kot so zdravstvo, šolstvo in infrastruktura.',
    },
    {
      'question': 'Kaj je dohodnina?',
      'options': [
        'Davek na premoženje',
        'Davek na dohodek',
        'Davek na promet blaga',
      ],
      'correctIndex': 1,
      'explanation': 'Dohodnina je davek, ki ga plačujemo od našega dohodka - plače, najemnin, ali drugih prihodkov.',
    },
    {
      'question': 'Zakaj plačujemo DDV?',
      'options': [
        'Za pokojnine',
        'Za zdravstvo',
        'Pri nakupu izdelkov in storitev',
      ],
      'correctIndex': 2,
      'explanation': 'DDV (davek na dodano vrednost) plačujemo pri vsakem nakupu. Del cene izdelka gre državi za financiranje javnih storitev.',
    },
    {
      'question': 'Kdaj oddate napoved za dohodnino?',
      'options': [
        'Do konca februarja',
        'Do konca marca',
        'Kadarkoli med letom',
      ],
      'correctIndex': 1,
      'explanation': 'Napoved za dohodnino je potrebno oddati do konca marca za preteklo leto.',
    },
    {
      'question': 'Kaj lahko zmanjša vašo dohodnino?',
      'options': [
        'Davčne olajšave',
        'Večji dohodek',
        'Več nakupov',
      ],
      'correctIndex': 0,
      'explanation': 'Davčne olajšave (npr. za vzdrževane družinske člane, investicije) lahko zmanjšajo znesek dohodnine, ki ga morate plačati.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KvizeduModel());
    
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void _nextCard(bool wasCorrect) {
    if (wasCorrect) {
      correctAnswers++;
    }
    
    setState(() {
      if (currentCardIndex < quizCards.length - 1) {
        currentCardIndex++;
        showAnswer = false;
        _flipController.reset();
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    final percentage = ((correctAnswers / quizCards.length) * 100).toInt();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '🎉 Kviz končan!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tvoj rezultat:',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF6B6B6B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$correctAnswers / ${quizCards.length}',
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8FD9C3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
        actions: [
          FFButtonWidget(
            onPressed: () {
              Navigator.pop(context);
              // Use setState to reset the quiz state before exiting
              setState(() {
                currentCardIndex = 0;
                correctAnswers = 0;
                showAnswer = false;
                _flipController.reset();
              });
              context.pop();
            },
            text: 'končaj',
            options: FFButtonOptions(
              width: double.infinity,
              height: 48,
              color: const Color(0xFF2D2D2D),
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = quizCards[currentCardIndex];
    final progress = (currentCardIndex + 1) / quizCards.length;

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
            'kviz o dohodnini',
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
            children: [
              // PROGRESS BAR (Now using standard LinearProgressIndicator)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'vprašanje ${currentCardIndex + 1}/${quizCards.length}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8FD9C3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFE8E8E8),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8FD9C3)),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              // FLASHCARD
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        final angle = _flipAnimation.value * 3.14159;
                        final isBack = _flipAnimation.value > 0.5;
                        
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: isBack
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(3.14159),
                                  child: _buildAnswerCard(currentCard),
                                )
                              : _buildQuestionCard(currentCard),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // TAP TO FLIP HINT
              if (!showAnswer)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        size: 16,
                        color: Color(0xFF6B6B6B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'tapni kartico za odgovor',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF6B6B6B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

              // ANSWER BUTTONS (only visible when answer is shown)
              if (showAnswer)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () => _nextCard(false),
                          text: '❌ napačno',
                          options: FFButtonOptions(
                            height: 56,
                            color: const Color(0xFFFFB3BC).withOpacity(0.3),
                            textStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D2D2D),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () => _nextCard(true),
                          text: '✓ pravilno',
                          options: FFButtonOptions(
                            height: 56,
                            color: const Color(0xFF8FD9C3),
                            textStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0,
                          ),
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

  // Helper widget for the question side of the card
  Widget _buildQuestionCard(Map<String, dynamic> card) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '❓',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 24),
            Text(
              card['question'],
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 32),
            // Displaying the options
            ...List.generate(
              card['options'].length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    card['options'][index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the answer side of the card
  Widget _buildAnswerCard(Map<String, dynamic> card) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8FD9C3), Color(0xFF6BC5A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(  
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(  
          child: Padding(
            padding: const EdgeInsets.all(24.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(
                  '✓',
                  style: const TextStyle(fontSize: 48, color: Colors.white),  
                ),
                const SizedBox(height: 16),  
                Text(
                  'pravilni odgovor:',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,  
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 10),  
                Text(
                  card['options'][card['correctIndex']],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,  
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),  
                Container(
                  padding: const EdgeInsets.all(16),  
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    card['explanation'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,  
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.4,  
                    ),
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