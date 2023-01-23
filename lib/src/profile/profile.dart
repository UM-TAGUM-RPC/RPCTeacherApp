import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/global/auth_global.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';

import '../../constant/constant.dart';
import '../../widget/widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                ref.read(isDuplicate.notifier).state = false;
                ref.read(authidentifier.notifier).signOut();
                context.goNamed(signIn);
              },
              child: Row(
                children: [
                  40.horizontalSpace,
                  SvgPicture.asset(
                    Asset.out,
                    width: 25.w,
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: GeneralSans(
                      semiBold: true,
                      fontSize: 16.sp,
                      align: TextAlign.left,
                      label: "Log out",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
