import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constant/constant.dart';
import '../../global/global.dart';
import '../../widget/widget.dart';

class NotifcationScreen extends ConsumerStatefulWidget {
  const NotifcationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotifcationScreenState();
}

class _NotifcationScreenState extends ConsumerState<NotifcationScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(currentUser);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                controller.markAsRead(
                    all: true, id: controller.user.id.toString());
              },
              behavior: HitTestBehavior.translucent,
              child: GeneralSans(
                label: "Mark as all read",
                align: TextAlign.left,
                fontSize: 12.sp,
                fontColor: CustomColor.darkColor.withOpacity(0.5),
                // lowerH: true,
              ),
            ),
            11.verticalSpace,
            Expanded(
                child: ListView.builder(
                    itemCount: controller.notifications.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 21),
                        child: Container(
                          width: 303,
                          decoration: BoxDecoration(
                              color: CustomColor.whiteF7,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: item.status == "unread"
                                    ? CustomColor.kindaRed
                                    : Colors.transparent,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 19),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GeneralSans(
                                    label:
                                        " ${DateFormat.yMMMd().add_jm().format(item.createdAt!)}",
                                    align: TextAlign.left,
                                    fontSize: 12.sp,
                                    fontColor:
                                        CustomColor.darkColor.withOpacity(0.5),
                                    //lowerH: true,
                                  ),
                                ),
                                6.verticalSpace,
                                GeneralSans(
                                  label: "Hello, RPC",
                                  align: TextAlign.left,
                                  fontSize: 12.sp,
                                  bold: true,
                                  fontColor: CustomColor.darkColor,
                                  //lowerH: true,
                                ),
                                9.verticalSpace,
                                GeneralSans(
                                  label: item.message,
                                  align: TextAlign.left,
                                  fontSize: 12.sp,
                                  fontColor: CustomColor.darkColor,

                                  // lowerH: true,
                                ),
                                10.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    controller.markAsRead(
                                        all: false, id: item.id.toString());
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GeneralSans(
                                      label: "Mark as read",
                                      align: TextAlign.left,
                                      fontSize: 12.sp,
                                      fontColor: CustomColor.darkColor
                                          .withOpacity(0.5),
                                      // lowerH: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
