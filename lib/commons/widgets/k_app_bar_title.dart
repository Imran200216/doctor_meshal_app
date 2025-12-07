import 'package:flutter/material.dart';

class KAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color surfaceTintColor;
  final Color shadowColor;
  final double elevation;
  final bool centerTitle;
  final String fontFamily;
  final double mobileFontSize;
  final double tabletFontSize;
  final double desktopFontSize;
  final FontWeight fontWeight;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final bool automaticallyImplyLeading;

  const KAppBarTitle({
    Key? key,
    required this.title,
    required this.backgroundColor,
    this.titleColor = Colors.white,
    this.surfaceTintColor = Colors.transparent,
    this.shadowColor = Colors.transparent,
    this.elevation = 0,
    this.centerTitle = false,
    this.fontFamily = "OpenSans",
    this.mobileFontSize = 20,
    this.tabletFontSize = 22,
    this.desktopFontSize = 24,
    this.fontWeight = FontWeight.w700,
    this.actions,
    this.leading,
    this.bottom,
    this.toolbarHeight,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
      toolbarHeight ?? (bottom?.preferredSize.height ?? kToolbarHeight));

  @override
  Widget build(BuildContext context) {
    // Determine screen type for responsive font sizing
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;

    return AppBar(
      centerTitle: centerTitle,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: isMobile
              ? mobileFontSize
              : isTablet
              ? tabletFontSize
              : desktopFontSize,
          fontWeight: fontWeight,
          color: titleColor,
        ),
      ),
    );
  }
}