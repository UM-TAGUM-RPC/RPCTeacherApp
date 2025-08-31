import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:rpcadvisorapp/global/global.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';

import '../../widget/widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    ref.read(currentUser.notifier).listentoSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUser);

    return Scaffold(
      backgroundColor: CustomColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 28.0,
            right: 28.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(currentUser.notifier).getCurrentMonitorSheets(),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: profile.listFiltered.length,
                      // reverse: true,
                      itemBuilder: (context, index) {
                        final item = profile.listFiltered[index];
                        return GestureDetector(
                          onTap: () {
                            //////////////////////////
                            context.pushNamed(monitorDetail, pathParameters: {
                              "monitorId": item.id.toString()
                            });
                            //////////////////////////
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: CustomColor.whiteF7,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomGeneralSans(
                                                label1: item.thesisTitle![0]
                                                    .toUpperCase(),
                                                label2: item.thesisTitle!
                                                    .substring(1),
                                                bold: true,
                                                fontSize: 24.sp,
                                              ),
                                              5.verticalSpace,
                                              Row(
                                                children: [
                                                  GeneralSans(
                                                    label: "CODE:",
                                                    fontColor:
                                                        CustomColor.darkColor,
                                                    fontSize: 11.sp,
                                                  ),
                                                  5.horizontalSpace,
                                                  GeneralSans(
                                                    label: item.zCode,
                                                    fontColor:
                                                        CustomColor.kindaRed,
                                                    fontSize: 11.sp,
                                                    bold: true,
                                                  ),
                                                ],
                                              ),
                                              5.verticalSpace,
                                              Row(
                                                children: [
                                                  GeneralSans(
                                                    label: "BRANCH",
                                                    fontColor:
                                                        CustomColor.darkColor,
                                                    fontSize: 11.sp,
                                                  ),
                                                  5.horizontalSpace,
                                                  GeneralSans(
                                                    label: "TAGUM",
                                                    fontColor:
                                                        CustomColor.kindaRed,
                                                    fontSize: 11.sp,
                                                    bold: true,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        5.horizontalSpace,
                                        GeneralSans(
                                          label: DateFormat.yMMMEd()
                                              .format(item.createdAt!),
                                          fontColor: CustomColor.darkColor
                                              .withOpacity(0.6),
                                          fontSize: 8.sp,
                                          bold: true,
                                        ),
                                      ],
                                    ),
                                    15.verticalSpace,
                                    Divider(
                                      color: CustomColor.darkColor
                                          .withOpacity(0.3),
                                      thickness: 1,
                                    ),
                                    15.verticalSpace,
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GeneralSans(
                                                label: "Proponents:",
                                                fontColor:
                                                    CustomColor.darkColor,
                                                fontSize: 11.sp,
                                              ),
                                              19.horizontalSpace,
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: profile
                                                      .returnModel(item.zCode)
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final itemP =
                                                        profile.returnModel(
                                                            item.zCode)[index];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5,
                                                        horizontal: 0,
                                                      ),
                                                      child: GeneralSans(
                                                        label:
                                                            "${itemP.firstName} ${itemP.lastName}",
                                                        fontColor: CustomColor
                                                            .darkColor,
                                                        fontSize: 11.sp,
                                                        bold: true,
                                                        align: TextAlign.left,
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        15.horizontalSpace,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      GeneralSans(
                                                        label: "Status:",
                                                        fontColor: CustomColor
                                                            .darkColor,
                                                        fontSize: 11.sp,
                                                        semiBold: true,
                                                      ),
                                                      10.horizontalSpace,
                                                      GeneralSans(
                                                        label: item.status,
                                                        fontColor: CustomColor
                                                            .kindaRed,
                                                        fontSize: 11.sp,
                                                        bold: true,
                                                      ),
                                                    ],
                                                  ),
                                                  5.verticalSpace,
                                                ],
                                              ),
                                              5.verticalSpace,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      GeneralSans(
                                                        label: "Next to do:",
                                                        fontColor: CustomColor
                                                            .darkColor,
                                                        fontSize: 11.sp,
                                                        semiBold: true,
                                                      ),
                                                      10.horizontalSpace,
                                                      // GeneralSans(
                                                      //   label: "PENDING",
                                                      //   fontColor:
                                                      //       CustomColor.kindaRed,
                                                      //   fontSize: 11.sp,
                                                      //   bold: true,
                                                      // ),
                                                    ],
                                                  ),
                                                  8.verticalSpace,
                                                  GeneralSans(
                                                    label: profile
                                                        .casesStatus(item),
                                                    fontColor:
                                                        CustomColor.kindaRed,
                                                    fontSize: 18.sp,
                                                    bold: true,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
