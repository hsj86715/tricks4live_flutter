import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LabelButton extends FlatButton {
  final VoidCallback onPressed;

  final String labelTxt;
  final String svgIcon;

  LabelButton(
      {@required this.labelTxt,
      @required this.svgIcon,
      @required this.onPressed,
      TextStyle textStyle})
      : super(
            onPressed: onPressed,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new SvgPicture.asset(svgIcon, width: 28.0, height: 28.0),
                const SizedBox(height: 4.0),
                new Text(labelTxt,
                    style: textStyle == null
                        ? new TextStyle(fontSize: 14.0)
                        : textStyle)
              ],
            ));

//  @override
//  State<StatefulWidget> createState() {
//    return new _LabelButtonState();
//  }
}

//class _LabelButtonState extends State<LabelButton> {
//  @override
//  Widget build(BuildContext context) {
//    return new Column(
//      children: <Widget>[
//        new SvgPicture.asset(widget.svgIcon, width: 28.0, height: 28.0),
//        const SizedBox(height: 4.0),
//        new Text(widget.labelTxt, style: new TextStyle(fontSize: 16.0))
//      ],
//    );
//  }
//}
