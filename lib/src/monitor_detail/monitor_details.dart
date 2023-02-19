import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rpcadvisorapp/constant/colors.dart';
import 'package:rpcadvisorapp/routes/route_generator.dart';

import '../../constant/fonts.dart';
import '../../global/global.dart';
import '../../widget/widget.dart';

class MonitorDetail extends ConsumerStatefulWidget {
  final String? monitorId;

  const MonitorDetail({super.key, this.monitorId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonitorDetailState();
}

class _MonitorDetailState extends ConsumerState<MonitorDetail> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUser);
    //// model
    final item = user.getmonitordetail(widget.monitorId);
    return Scaffold(
      backgroundColor: CustomColor.white,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 28.0,
          right: 28.0,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomGeneralSans(
                          label1: item.thesisTitle![0].toUpperCase(),
                          label2: item.thesisTitle!.substring(1),
                          bold: true,
                          fontSize: 24.sp,
                        ),
                        5.verticalSpace,
                        Row(
                          children: [
                            GeneralSans(
                              label: "CODE:",
                              fontColor: CustomColor.darkColor,
                              fontSize: 11.sp,
                            ),
                            5.horizontalSpace,
                            GeneralSans(
                              label: item.zCode,
                              fontColor: CustomColor.kindaRed,
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
                              fontColor: CustomColor.darkColor,
                              fontSize: 11.sp,
                            ),
                            5.horizontalSpace,
                            GeneralSans(
                              label: "TAGUM",
                              fontColor: CustomColor.kindaRed,
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
                    label: DateFormat.yMMMEd().format(item.createdAt!),
                    fontColor: CustomColor.darkColor.withOpacity(0.6),
                    fontSize: 8.sp,
                    bold: true,
                  ),
                ],
              ),
              15.verticalSpace,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Divider(
                  color: CustomColor.darkColor.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
              15.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GeneralSans(
                          label: "Proponents:",
                          fontColor: CustomColor.darkColor,
                          fontSize: 11.sp,
                        ),
                        19.horizontalSpace,
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: user.returnModel(item.zCode).length,
                            itemBuilder: (context, index) {
                              final itemP = user.returnModel(item.zCode)[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 0,
                                ),
                                child: GeneralSans(
                                  label: "${itemP.firstName} ${itemP.lastName}",
                                  fontColor: CustomColor.darkColor,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GeneralSans(
                                label: "Status:",
                                fontColor: CustomColor.darkColor,
                                fontSize: 11.sp,
                                semiBold: true,
                              ),
                              10.horizontalSpace,
                              GeneralSans(
                                label: item.status,
                                fontColor: CustomColor.kindaRed,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GeneralSans(
                                label: "Current to approve:",
                                fontColor: CustomColor.darkColor,
                                fontSize: 11.sp,
                                semiBold: true,
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                          8.verticalSpace,
                          GeneralSans(
                            label: user.casesStatus(item),
                            fontColor: CustomColor.kindaRed,
                            fontSize: 18.sp,
                            bold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              25.verticalSpace,
              ButtonRounded(
                label: "Approved",
                onPressed: () {},
                fontColor: CustomColor.white,
                fontSize: 12.sp,
                backColor: CustomColor.kindaRed,
                round: 5,
                heigth: 36.h,
                width: 295.w,
              ),
              15.verticalSpace,
              15.verticalSpace,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Divider(
                  color: CustomColor.darkColor.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
              15.verticalSpace,
              GeneralSans(
                label: "Leave a comment:",
                fontColor: CustomColor.darkColor,
                fontSize: 10.sp,
              ),
              15.verticalSpace,
              TextFormField(
                controller: user.leaveComment,
                cursorColor: CustomColor.kindaRed,
                textAlign: TextAlign.left,
                autofocus: false,
                showCursor: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                  color: CustomColor.darkColor,
                  fontSize: 15.sp,
                  fontFamily: CustomFont.medium,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (p0) {},
                validator: (s) => null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  hintText: "Advisor Comment\n\n\n\n",
                  hintStyle: TextStyle(
                    color: CustomColor.darkColor.withOpacity(0.5),
                    fontSize: 15.sp,
                    fontFamily: CustomFont.medium,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: CustomColor.whiteF7,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: CustomColor.whiteF7,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: CustomColor.whiteF7,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: CustomColor.whiteF7,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              15.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: ButtonRounded(
                  onPressed: () {},
                  label: "Leave Comment",
                  width: 145.w,
                  heigth: 36.h,
                  fontSize: 13.sp,
                  round: 5.0,
                ),
              ),
              25.verticalSpace,
              GestureDetector(
                onTap: () {
                  context.pushNamed(advisorComment);
                },
                child: GeneralSans(
                  label: "Show Advisor Comments",
                  fontColor: CustomColor.darkColor,
                  fontSize: 12.sp,
                  semiBold: true,
                ),
              ),
              25.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
