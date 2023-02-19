import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/global/global.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';
import 'package:rpcadvisorapp/widget/widget.dart';

import '../../constant/constant.dart';

final navSelection = AutoDisposeStateProvider<int>((ref) => 0);

class HomeNav extends ConsumerStatefulWidget {
  final Widget? child;

  const HomeNav(this.child, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeNavState();
}

class _HomeNavState extends ConsumerState<HomeNav> {
  @override
  void initState() {
    ref.read(currentUser.notifier).getUserprofile();
    ref.read(currentUser.notifier).getCurrentMonitorSheets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navSelection);
    final profile = ref.watch(currentUser);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColor.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(135.h),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28.0,
                right: 28.0,
              ),
              child: Column(
                children: [
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomGeneralSans(
                              label1: "W",
                              label2: "elcome",
                              fontColor: CustomColor.darkColor,
                              fontSize: 32.sp,
                              bold: true,
                            ),
                            GeneralSans(
                              label: profile.user!.firstName != null
                                  ? "${profile.user!.firstName} ${profile.user!.lastName}"
                                  : "",
                              fontSize: 15.sp,
                              align: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        Asset.pen,
                        width: 25.w,
                      ),
                      25.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          DialogCustom.diualogEnterCode(context);
                        },
                        child: SvgPicture.asset(
                          Asset.add,
                          width: 25.w,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Divider(
                    color: CustomColor.gray.withOpacity(0.5),
                    thickness: 1,
                  ),
                  15.verticalSpace,
                ],
              ),
            ),
          ),
        ),
        body: widget.child,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomIndicatorBar(
              activeColor: CustomColor.kindaRed,
              indicatorColor: CustomColor.kindaRed,
              inactiveColor: CustomColor.darkColor.withOpacity(0.7),
              shadow: false,
              currentIndex: index,
              onTap: (count) {
                onTapUser(count);
              },
              items: [
                BottomIndicatorNavigationBarItem(
                    icon: Asset.home, count: 0, showBadge: false),
                BottomIndicatorNavigationBarItem(
                    icon: Asset.profile, count: 0, showBadge: false),
                BottomIndicatorNavigationBarItem(
                  icon: Asset.notif,
                  count: 0,
                  showBadge: false,
                ),
                BottomIndicatorNavigationBarItem(
                    icon: Asset.out, count: 0, showBadge: false)
              ],
            ),
          ],
        ),
      ),
    );
  }

  onTapUser(int? count) {
    ref.read(navSelection.notifier).state = count!;
    switch (count) {
      case 0:
        context.goNamed(home);
        break;
      case 1:
        context.goNamed(accounts);
        break;
      case 2:
        context.goNamed(notification);
        break;
      case 3:
        //context.goNamed(notification);

        DialogCustom.dialogoption(
          context: context,
          yes: () {
            ref.read(isDuplicate.notifier).state = false;
            ref.read(authidentifier.notifier).signOut();
            context.goNamed(signIn);
          },
          no: () {
            context.pop();
          },
        );
        break;
      default:
    }
  }
}
