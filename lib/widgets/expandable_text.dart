import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String str;
  final int allowed;

  const ExpandableText({required this.str, super.key, required this.allowed});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool needsExpanse = false;
  bool expanded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var span = TextSpan(text: widget.str);
      var tp = TextPainter(
        text: span,
        maxLines: widget.allowed,
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: context.size!.width);

      setState(() {
        needsExpanse = tp.didExceedMaxLines;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !needsExpanse
        ? Text(widget.str)
        : Column(
            children: [
              Text(
                widget.str,
                maxLines: expanded ? null : widget.allowed,
                overflow: expanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Text(
                    expanded ? "Show less" : "Show more",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
