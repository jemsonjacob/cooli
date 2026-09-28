import '/utils/colors.dart';
import 'package:flutter/material.dart';

class AppCustomSwitch extends StatefulWidget {
  final Function(bool value) onChanged;
  final bool value;
  // final double? height;
  // final double? width;

  const AppCustomSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    // this.height=24,
    // this.width=48,
  });

  @override
  State<AppCustomSwitch> createState() => _AppCustomSwitchState();
}

class _AppCustomSwitchState extends State<AppCustomSwitch>
    with TickerProviderStateMixin {
  final _keyContent = GlobalKey();
  late final AnimationController _animController;
  late final Animation<Color?> _bgColorAnim, _circleColorAnim, _borderColorAnim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _bgColorAnim = ColorTween(begin: Colors.white, end: AppColors().primaryButtonColor)
        .animate(_animController);

    _circleColorAnim = ColorTween(begin: AppColors().primaryButtonColor, end: Colors.white)
        .animate(_animController);

    _borderColorAnim =
        ColorTween(begin:AppColors(). primaryButtonColor, end: AppColors().primaryButtonColor)
            .animate(_animController);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppCustomSwitch oldWidget) {
    if (oldWidget.value != widget.value) {
      _resetAnimation(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _keyContent,
      onTap: () {
        widget.onChanged(!widget.value);
      },
      onHorizontalDragUpdate: (details) =>
          _onHorizontalDragUpdate(context, details),
      onHorizontalDragCancel: () {
        _onDragCancel(context);
      },
      onHorizontalDragEnd: (details) {
        _onHorizontalDragEnd(context);
      },
      child: AnimatedBuilder(
          animation: _animController,
          builder: (context, _) {
            return Container(
              height: 24,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: _borderColorAnim.value ?? Colors.transparent),
                color: _bgColorAnim.value,
              ),
              alignment:
                  FractionalOffset(_animController.value.clamp(0.1, 0.9), 0.50),
              child: _ThisCircleWidget(
                color: _circleColorAnim.value,
              ),
            );
          }),
    );
  }

  void _onHorizontalDragUpdate(
      BuildContext context, DragUpdateDetails details) {
    final size = _keyContent.currentContext!.findRenderObject() as RenderBox;
    final val = details.localPosition.dx;
    double perct = val / size.size.width;
    perct = perct.clamp(0.0, 1.0);
    _animController.value = perct;
  }

  void _onHorizontalDragEnd(BuildContext context) async {
    // await _resetAnimation();
    bool val;

    if (_animController.value > 0.5) {
      val = true;
    } else {
      val = false;
    }

    // if (widget.value == val) {
    await _resetAnimation(val);
    // }
    widget.onChanged(val);
  }

  Future<void> _resetAnimation(bool val) async {
    try {
      if (val) {
        _animController.forward().orCancel;
      } else {
        _animController.reverse().orCancel;
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  void _onDragCancel(BuildContext context) {
    _resetAnimation(widget.value);
  }
}

class _ThisCircleWidget extends StatelessWidget {
  final Color? color;
  const _ThisCircleWidget({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
