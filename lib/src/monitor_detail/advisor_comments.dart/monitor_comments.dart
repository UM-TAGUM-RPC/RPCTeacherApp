import 'package:enhanced_read_more/enhanced_read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/global/global.dart';

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
            25.verticalSpace,
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
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
                                  )
                                ],
                              ),
                              5.verticalSpace,
                              Divider(
                                color: CustomColor.darkColor.withOpacity(0.2),
                                thickness: 1,
                              ),
                              5.verticalSpace,
                              ReadMoreText(
                                'Choi!, imung mga widget tarunga animal ka, Balik sako sunoddapat align na cya para dili ma bungkag then diha nako mu.....',
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
