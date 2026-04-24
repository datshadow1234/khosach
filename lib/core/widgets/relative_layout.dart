import 'dart:math';

import 'package:flutter/material.dart';
// kích thước chuẩn
const double guidelineBaseWidth = 430;
const double guidelineBaseHeight = 932;

typedef _RelativeBuilderFunction = Widget Function(
    BuildContext,
    double,
    double,
    double Function(double),
    double Function(double),
    );

class RelativeBuilder extends StatelessWidget {
  final double? scale;

  final _RelativeBuilderFunction builder;

  const RelativeBuilder({
    super.key,
    this.scale,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return _RelativeBuilder(scale: scale, builder: builder);
  }
}

class _RelativeBuilder extends StatefulWidget {
  final double? scale;
  final _RelativeBuilderFunction? builder;

  const _RelativeBuilder({
    this.scale,
    this.builder,
  });

  @override
  _RelativeBuilderState createState() => _RelativeBuilderState();
}

class _RelativeBuilderState extends State<_RelativeBuilder> {
  final double _guidelineBaseWidth = guidelineBaseWidth;
  final double _guidelineBaseHeight = guidelineBaseHeight;

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, _windowHeight, _windowWidth, _sy, _sx);
  }

  Size get _size => MediaQuery.of(context).size;

  double get _windowHeight => _size.height;
  double get _windowWidth => _size.width;

  double _sy(double value) {
    return value *
        (max(_windowHeight, _windowWidth) / _guidelineBaseHeight) *
        (widget.scale ?? 1);
  }

  double _sx(double value) {
    return value *
        (min(_windowHeight, _windowWidth) / _guidelineBaseWidth) *
        (widget.scale ?? 1);
  }
}

class StaticRelativeBuilder {
  final BuildContext context;

  StaticRelativeBuilder(this.context);

  Size get size => MediaQuery.of(context).size;

  double get windowHeight => size.height;
  double get windowWidth => size.width;

  double sy(double value) {
    return value * (max(windowHeight, windowWidth) / guidelineBaseHeight);
  }

  double sx(double value) {
    return value * (min(windowHeight, windowWidth) / guidelineBaseWidth);
  }
}