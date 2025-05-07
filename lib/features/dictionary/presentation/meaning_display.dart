import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:flutter/material.dart';

class MeaningDisplay extends StatefulWidget {
  const MeaningDisplay({
    super.key,
    required this.partOfSpeech,
    required this.definitions,
  });

  final String partOfSpeech;
  final List<WordDefinition> definitions;

  @override
  State<MeaningDisplay> createState() => _MeaningDisplayState();
}

class _MeaningDisplayState extends State<MeaningDisplay> {
  var readMore = false;

  @override
  Widget build(BuildContext context) {
    var definitions = widget.definitions;
    List<Widget> definitionsView() {
      const maxView = 3;
      List<Widget> children = [];
      for (int i = 0; i < (readMore ? definitions.length : maxView); i++) {
        if (i >= definitions.length) break;

        var d = definitions[i];
        children.add(
          ListTile(
            title: Text(d.definition),
            leading: Icon(Icons.abc_outlined),
          ),
        );
      }
      if (definitions.length > maxView) {
        if (!readMore) {
          children.add(
            ElevatedButton(
              onPressed: () {
                setState(() {
                  readMore = true;
                });
              },
              child: Text("read more"),
            ),
          );
        } else {
          children.add(
            ElevatedButton(
              onPressed: () {
                setState(() {
                  readMore = false;
                });
              },
              child: Text("collapsed"),
            ),
          );
        }
      }

      return children;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.zero),
            child: Text(widget.partOfSpeech),
          ),
        ),
        LimitedBox(
          maxHeight: 300,
          maxWidth: 200,
          child: ListView(shrinkWrap: true, children: [...definitionsView()]),
        ),
      ],
    );
  }
}
