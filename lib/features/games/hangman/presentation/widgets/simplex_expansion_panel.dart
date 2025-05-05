import 'package:flutter/material.dart';

class SimplexExpansionPanel extends StatefulWidget {
  const SimplexExpansionPanel({
    super.key,
    required this.header,
    required this.desc,
  });
  final String header;
  final String desc;

  @override
  State<SimplexExpansionPanel> createState() => _SimplexExpansionPanelState();
}

class _SimplexExpansionPanelState extends State<SimplexExpansionPanel> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          title: Row(
            children: [
              Expanded(child: Text(widget.header)),
              AnimatedRotation(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                turns: isExpanded ? .5 : 0, // Rotates 360 degrees
                child: Icon(Icons.expand_more, size: 30),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: Durations.medium1,
          curve: Curves.easeInOut,
          child:
              !isExpanded
                  ? SizedBox.shrink()
                  : ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.desc),
                    ),
                  ),
        ),
      ],
    );
  }
}
