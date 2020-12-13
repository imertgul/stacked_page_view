library stacked_page_view;

import 'dart:math';
import 'package:flutter/material.dart';

/// A Calculator.
class StackPageView extends StatefulWidget {
  StackPageView({
    Key key,
    this.index,
    this.controller,
    this.child,
  })  : assert(index != null),
        assert(child != null),
        assert(controller != null),
        super(key: key);
  final int index;
  final PageController controller;
  final Widget child;
  @override
  _StackPageViewState createState() => _StackPageViewState();
}

class _StackPageViewState extends State<StackPageView> {
  int currentPosition = 0;
  double pagePosition = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.controller.position.haveDimensions) {
      widget.controller.addListener(() {
        _listener();
      });
    }
  }

  _listener() {
    if (this.mounted)
      setState(() {
        pagePosition = num.parse(widget.controller.page.toStringAsFixed(4));
        currentPosition = widget.controller.page.floor();
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 15.0;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double delta = pagePosition - widget.index;
          double start = (size.height * 0.105) * delta.abs() * 10;
          double sides = padding * max(-delta, 0.0);
          double opac = (sides / 0.5) * 0.1;
          double anotheropac = 0.0;
          if (num.parse(opac.toStringAsFixed(2)) <= 1.0) {
            anotheropac = num.parse(opac.toStringAsFixed(3)) * 0.5;
          } else if (num.parse(opac.toStringAsFixed(2)) >= 1.0) {
            anotheropac = 0.5;
          } else {
            anotheropac = num.parse(opac.toStringAsFixed(3)) * 0.07;
          }
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: currentPosition == widget.index
                  ? EdgeInsets.all(0)
                  : EdgeInsets.only(left: sides, right: sides, bottom: sides),
              child: ColorFiltered(
                colorFilter: currentPosition != widget.index
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(anotheropac), BlendMode.darken)
                    : ColorFilter.mode(
                        Colors.black.withOpacity(0.01), BlendMode.darken),
                child: ClipRRect(
                  child: Transform.translate(
                    offset: currentPosition != widget.index
                        ? Offset(0, -start)
                        : Offset(0, 0),
                    child: ClipRRect(
                      borderRadius: currentPosition != widget.index
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0)),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Scaffold(body: widget.child),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}