import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' show lerpDouble;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rpcadvisorapp/widget/text/normal_text.dart';

import '../../constant/constant.dart';

// ignore: must_be_immutable
class BottomIndicatorBar extends StatefulWidget {
  final Color indicatorColor;
  final Color activeColor;
  final Color inactiveColor;
  final bool shadow;
  int currentIndex;
  // late String iconData;
  final ValueChanged<int> onTap;
  final List<BottomIndicatorNavigationBarItem> items;

  BottomIndicatorBar({
    Key? key,
    required this.onTap,
    required this.items,
    this.activeColor = Colors.teal,
    this.inactiveColor = Colors.grey,
    this.indicatorColor = Colors.grey,
    this.shadow = true,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State createState() => _BottomIndicatorBarState();
}

class _BottomIndicatorBarState extends State<BottomIndicatorBar> {
  double barHeight = 88;
  double indicatorh = 2;

  List<BottomIndicatorNavigationBarItem> get items => widget.items;

  double width = 0;
  String iconData = "";
  late Color activeColor;
  Duration duration = const Duration(milliseconds: 170);

  double? _getIndicatorPosition(int index) {
    var isLtr = Directionality.of(context) == TextDirection.ltr;
    if (isLtr) {
      return lerpDouble(-1.0, 1.0, index / (items.length - 1));
    } else {
      return lerpDouble(1.0, -1.0, index / (items.length - 1));
    }
  }

  @override
  void initState() {
    super.initState();
    iconData = widget.items[0].icon!;
  }

  @override
  Widget build(BuildContext context) {
    //width = MediaQuery.of(context).size.width;
    width = 375;
    activeColor = widget.activeColor;

    return Container(
      width: width,
      height: barHeight + MediaQuery.of(context).viewPadding.bottom,
      decoration: BoxDecoration(
        color: CustomColor.white,
        boxShadow: widget.shadow
            ? [
                const BoxShadow(color: Colors.black12, blurRadius: 10),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: items.map((item) {
                      var index = items.indexOf(item);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _select(index, item),
                          child: _buildItemWidget(
                            item,
                            index == widget.currentIndex,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 375,
              child: AnimatedAlign(
                alignment:
                    Alignment(_getIndicatorPosition(widget.currentIndex)!, 0),
                curve: Curves.linear,
                duration: duration,
                child: SizedBox(
                  width: 355 * 0.9 / items.length,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      color: widget.indicatorColor,
                      width: 25.5.w,
                      height: indicatorh,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _select(int index, BottomIndicatorNavigationBarItem item) {
    widget.currentIndex = index;
    iconData = item.icon!;
    widget.onTap(widget.currentIndex);

    setState(() {});
  }

  Widget _setIcon(BottomIndicatorNavigationBarItem item) {
    return Badge(
      showBadge: item.showBadge!,
      animationType: BadgeAnimationType.slide,
      animationDuration: const Duration(milliseconds: 600),
      badgeColor: CustomColor.darkColor,
      badgeContent: GeneralSans(
        label: "${item.count}",
        fontSize: 11.sp,
        fontColor: CustomColor.white,
      ),
      child: SvgPicture.asset(
        item.icon!,
        color: iconData == item.icon ? activeColor : null,
        height: 25.5.h,
        width: 25.5.w,
      ),
    );
  }

  Widget _buildItemWidget(
      BottomIndicatorNavigationBarItem item, bool isSelected) {
    return Container(
      color: CustomColor.white,
      height: barHeight,
      width: width / items.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _setIcon(item),
        ],
      ),
    );
  }
}

class BottomIndicatorNavigationBarItem {
  final String? icon;
  final Color? backgroundColor;
  final int? count;
  final bool? showBadge;
  BottomIndicatorNavigationBarItem(
      {required this.icon,
      this.backgroundColor = Colors.white,
      this.count,
      this.showBadge});
}
