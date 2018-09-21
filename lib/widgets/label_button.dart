import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconDirection { left, top, right, bottom }

class LabelButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String labelTxt;
  final String svgIcon;
  final TextStyle textStyle;
  final IconDirection direction;
  final double iconSize;

  LabelButton(
      {@required this.labelTxt,
      @required this.svgIcon,
      @required this.onPressed,
      this.textStyle = const TextStyle(fontSize: 14.0),
      this.direction = IconDirection.top,
      this.iconSize = 28.0});

  @override
  Widget build(BuildContext context) {
    List<Widget> labelBtn = <Widget>[
      SvgPicture.asset(svgIcon, width: iconSize, height: iconSize),
      const SizedBox(height: 4.0, width: 4.0),
      Text(labelTxt, style: textStyle)
    ];
    if (direction == IconDirection.right || direction == IconDirection.bottom) {
      labelBtn = List.of(labelBtn.reversed);
    }
    Widget child;
    if (direction == IconDirection.left || direction == IconDirection.right) {
      child = Row(mainAxisSize: MainAxisSize.min, children: labelBtn);
    } else {
      child = Column(mainAxisSize: MainAxisSize.min, children: labelBtn);
    }
    return RawMaterialButton(
        child: Padding(padding: const EdgeInsets.all(4.0), child: child),
        onPressed: onPressed);
  }
}
