import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';

const _closeIcon = """
<svg 
    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
    <g clip-path="url(#clip0)" fill-rule="evenodd" clip-rule="evenodd">
        <path d="M19.1 19.819L.283 1 1.975-.064l18.82 18.819-1.694 1.064z"/>
        <path d="M.001 18.819L18.82 0l1.693 1.064-18.818 18.82L0 18.818z"/>
    </g>
    <defs>
        <clipPath id="clip0">
            <path d="M0 0h20v20H0z"/>
        </clipPath>
    </defs>
</svg>
""";

const _maximizeIcon = """
<svg fill="none"
    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M17.5 2.5h-15v15h15v-15zM.5.5v19h19V.5H.5z" fill="#fff"/>
</svg>
""";

const _minimizeIcon = """
<svg
    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M20 12H0v-2h20v2z"/>
</svg>
""";

class CloseIcon extends StatelessWidget {
  final Color color;
  CloseIcon({
    Key key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_closeIcon, color: color);
  }
}

class MaximizeIcon extends StatelessWidget {
  final Color color;
  MaximizeIcon({
    Key key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_maximizeIcon, color: color);
  }
}

class MinimizeIcon extends StatelessWidget {
  final Color color;
  MinimizeIcon({
    Key key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_minimizeIcon, color: color);
  }
}
