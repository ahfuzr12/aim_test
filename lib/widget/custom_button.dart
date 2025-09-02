import "package:aim_test/res/colors.dart";
import "package:aim_test/res/dimens.dart";
import "package:flutter/material.dart";

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final Size? maximumSize;
  final OutlinedBorder? shape;
  final IconData? iconData;
  final Widget label;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = ColorResources.primaryDark,
    this.foregroundColor,
    this.padding = const EdgeInsets.all(Dimens.paddingSmall),
    this.minimumSize = const Size(Dimens.buttonWidth, Dimens.buttonHeight),
    this.maximumSize,
    this.shape,
    this.iconData,
  });

  @override
  State<StatefulWidget> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _loading = false;
  late Color backgroundColor;
  late Color foregroundColor;

  Widget _buildIconButton() {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
        padding: WidgetStateProperty.all(widget.padding),
        minimumSize: WidgetStateProperty.all(widget.minimumSize),
        maximumSize: widget.maximumSize != null ? WidgetStateProperty.all(widget.maximumSize) : null,
        shape: WidgetStateProperty.all(
          widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.buttonRadius)),
        ),
      ),
      icon: Icon(widget.iconData, color: foregroundColor, size: Dimens.iconSize),
      label: _loading
          ? SizedBox(
              width: Dimens.iconSize,
              height: Dimens.iconSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(foregroundColor),
                strokeWidth: 2.0,
              ),
            )
          : widget.label,
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
        padding: WidgetStateProperty.all(widget.padding),
        minimumSize: WidgetStateProperty.all(widget.minimumSize),
        maximumSize: widget.maximumSize != null ? WidgetStateProperty.all(widget.maximumSize) : null,
        shape: WidgetStateProperty.all(
            widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.buttonRadius))),
      ),
      child: _loading
          ? SizedBox(
              width: Dimens.iconSize,
              height: Dimens.iconSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(foregroundColor),
                strokeWidth: 2.0,
              ),
            )
          : widget.label,
    );
  }

  void setLoading({required bool loading}) {
    if (_loading != loading) setState(() => _loading = loading);
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = _loading ? ColorResources.disable : widget.backgroundColor;
    foregroundColor = _loading ? ColorResources.disableText : ColorResources.textInverse;
    return widget.iconData == null ? _buildButton() : _buildIconButton();
  }
}
