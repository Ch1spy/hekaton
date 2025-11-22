import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'prvastran_model.dart';
export 'prvastran_model.dart';

class PrvastranWidget extends StatefulWidget {
  const PrvastranWidget({super.key});

  static String routeName = 'prvastran';
  static String routePath = '/prvastran';

  @override
  State<PrvastranWidget> createState() => _PrvastranWidgetState();
}

class _PrvastranWidgetState extends State<PrvastranWidget> {
  late PrvastranModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrvastranModel());
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}
