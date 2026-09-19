import 'package:flutter/material.dart';

class AnimatedListItem extends StatefulWidget {
  final int index;
  final String title;

  const AnimatedListItem({super.key, required this.index, required this.title});

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (!mounted) return;

      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: visible ? 1 : 0,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.only(bottom: 12, left: visible ? 0 : 40),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.animation),
            title: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
