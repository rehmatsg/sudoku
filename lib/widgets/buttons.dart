import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';
import '../rehmat.dart';

class TextIconButton extends StatefulWidget {

  const TextIconButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
    this.padding
  }) : super(key: key);

  final String text;

  final IconData icon;

  final Color? color;
  final EdgeInsetsGeometry? padding;

  final Function() onPressed;

  @override
  _TextIconButtonState createState() => _TextIconButtonState();
}

class _TextIconButtonState extends State<TextIconButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kBorderRadius),
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: widget.color ?? Palette.of(context).surfaceVariant,
          border: Border.all(
            color: Palette.of(context).onSurfaceVariant.withOpacity(0.2),
            width: 0
          )
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: Palette.of(context).onSecondaryContainer
              ),
              Container(width: 5,),
              Text(
                widget.text,
                style: Theme.of(context).textTheme.button?.copyWith(
                  color: Palette.of(context).onSurfaceVariant
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {

  PrimaryButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.feedback = true,
    this.disabled = false,
    /// If true, the button will show a loading indicator when pressed until the onPressed function finishes
    this.autoLoading = false
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPress;
  final bool feedback;
  final bool disabled;
  final bool autoLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {

  @override
  Widget build(BuildContext context) {
    return _RenderButton(
      child: widget.child,
      disabled: widget.disabled,
      feedback: widget.feedback,
      onLongPress: widget.onLongPress,
      onPressed: widget.onPressed,
      backgroundColor: Palette.of(context).primaryContainer,
      textColor: Palette.of(context).onPrimaryContainer
    );
  }

}

class SecondaryButton extends StatefulWidget {

  SecondaryButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.feedback = true,
    this.disabled = false,
    /// If true, the button will show a loading indicator when pressed until the onPressed function finishes
    this.autoLoading = false
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPress;
  final bool feedback;
  final bool disabled;
  final bool autoLoading;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();

}

class _SecondaryButtonState extends State<SecondaryButton> {

  @override
  Widget build(BuildContext context) {
    return _RenderButton(
      child: widget.child,
      disabled: widget.disabled,
      feedback: widget.feedback,
      onLongPress: widget.onLongPress,
      onPressed: widget.onPressed,
      backgroundColor: Palette.of(context).secondaryContainer,
      textColor: Palette.of(context).onSecondaryContainer,
    );
  }

}

class Button extends StatefulWidget {

  Button({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.feedback = true,
    this.disabled = false,
    this.backgroundColor,
    this.textColor,
    this.shadow,
    this.border
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPress;
  final bool feedback;
  final bool disabled;

  final Color? backgroundColor;
  final Color? textColor;
  final BoxShadow? shadow;
  final Border? border;

  @override
  State<Button> createState() => _ButtonState();
  
}

class _ButtonState extends State<Button> {

  @override
  Widget build(BuildContext context) {
    return _RenderButton(
      child: widget.child,
      disabled: widget.disabled,
      feedback: widget.feedback,
      onLongPress: widget.onLongPress,
      onPressed: widget.onPressed,
      backgroundColor: widget.backgroundColor ?? Palette.of(context).surfaceVariant,
      textColor: widget.textColor ?? Palette.of(context).onSurfaceVariant,
      shadow: widget.shadow,
    );
  }

}

class _RenderButton extends StatefulWidget {

  const _RenderButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.feedback = true,
    this.disabled = false,
    required this.backgroundColor,
    required this.textColor,
    this.shadow,
  }) : super(key: key);

  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPress;
  final bool feedback;
  final bool disabled;
  final Color backgroundColor;
  final Color textColor;
  final BoxShadow? shadow;

  @override
  State<_RenderButton> createState() => _RenderButtonState();
}

class _RenderButtonState extends State<_RenderButton> {

  double radius = 60;

  bool isLoading = false;
  
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      fn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => reduceRadius(),
      onTapDown: (details) => reduceRadius(),
      onPanCancel: () => resetRadius(),
      onTapUp: (details) => resetRadius(),
      onTapCancel: () => resetRadius(),
      onTap: widget.onPressed != null ? () {
        reduceRadius();
        TapFeedback.tap();
        widget.onPressed?.call();
        Future.delayed(const Duration(milliseconds: 190), () => resetRadius());
      } : null,
      child: AnimatedSize(
        duration: kAnimationDuration,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Sprung.criticallyDamped,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              if (widget.shadow != null) widget.shadow!,
            ]
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: widget.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 17
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void reduceRadius() => setState(() => radius = 10);

  void resetRadius() => setState(() => radius = 40);

}