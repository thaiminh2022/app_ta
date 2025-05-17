import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/features/leveling/services/cefr_level_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CefrTest extends StatefulWidget {
  const CefrTest({super.key, required this.level});
  final WordCerf level;

  @override
  State<CefrTest> createState() => _CefrTestState();
}

class _CefrTestState extends State<CefrTest> {
  final CefrLevelUpService _service = CefrLevelUpService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWord();
    Future.microtask(() async {
      await loadWord();
    });
  }

  Future<void> loadWord() async {
    var casesRes = await _service.loadTestCase(
      widget.level,
      context.read<AppState>(),
    );
    _service.setTestCase(casesRes.unwrap());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: PageHeader("Thi lên cấp")),
      body: Center(
        child: Column(
          children: [
            isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                  child: ListView(
                    children: [
                      for (int i = 0; i < _service.cases.length; i++)
                        Card(
                          child: Column(
                            children: [
                              Text(_service.cases[i].definition),
                              Text("Answer: ${_service.cases[i].answer}"),
                              for (var op in _service.cases[i].option.keys)
                                OutlinedButton(
                                  onPressed: () {
                                    _service.toggleChoose(i, op);
                                    setState(() {});
                                  },

                                  child: Text(
                                    op,
                                    style: TextStyle(
                                      color:
                                          _service.getChooseInfo(i, op)
                                              ? Colors.red
                                              : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible: !isLoading,
                        child: ElevatedButton(
                          onPressed: () {
                            var pass = _service.submit();

                            if (pass) {
                              appState.levelUp();
                              appState.saveLevelData();
                            }
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: Text(
                                      pass ? "You pass" : "You failed",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          Navigator.pop(context);
                                        },
                                        child: Text("close"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: Text("Submit"),
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
