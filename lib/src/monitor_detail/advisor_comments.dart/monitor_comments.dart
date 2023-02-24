import 'package:enhanced_read_more/enhanced_read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rpcadvisorapp/global/global.dart';
import 'package:rpcadvisorapp/src/monitor_detail/monitor_function/monitor_function.dart';

import '../../../constant/constant.dart';
import '../../../widget/widget.dart';

class MonitorAdvisorComments extends ConsumerStatefulWidget {
  const MonitorAdvisorComments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonitorAdvisorCommentsState();
}

class _MonitorAdvisorCommentsState
    extends ConsumerState<MonitorAdvisorComments> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUser);
    final comments = ref.watch(monitorSheetDetails);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 28.0,
          right: 28.0,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: GeneralSans(
                  label: "Back",
                  fontColor: CustomColor.darkColor,
                  fontSize: 12.sp,
                  semiBold: true,
                ),
              ),
            ),
            15.verticalSpace,
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final item = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CustomColor.whiteF7,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GeneralSans(
                                          label:
                                              "${user.user!.firstName} ${user.user!.lastName}",
                                          fontColor: CustomColor.kindaRed,
                                          fontSize: 12.sp,
                                          bold: true,
                                        ),
                                        GeneralSans(
                                          label: "Advisor",
                                          fontColor: CustomColor.darkColor,
                                          fontSize: 8.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  GeneralSans(
                                    label: DateFormat.yMMMEd()
                                        .add_jms()
                                        .format(item.createdAt!.toLocal()),
                                    fontColor:
                                        CustomColor.darkColor.withOpacity(0.6),
                                    fontSize: 8.sp,
                                    bold: true,
                                  ),
                                ],
                              ),
                              5.verticalSpace,
                              Divider(
                                color: CustomColor.darkColor.withOpacity(0.2),
                                thickness: 1,
                              ),
                              5.verticalSpace,
                              ReadMoreText(
                                item.comment ?? "",
                                trimLines: 2,
                                collapsed: true,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '\n\nShow more...',
                                trimExpandedText: '\n\nShow less...',
                                style: TextStyle(
                                  color: CustomColor.darkColor,
                                  fontFamily: CustomFont.regular,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                                moreStyle: TextStyle(
                                  color: CustomColor.kindaRed,
                                  fontFamily: CustomFont.bold,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                                lessStyle: TextStyle(
                                  color: CustomColor.kindaRed,
                                  fontFamily: CustomFont.bold,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
