import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rpcadvisorapp/constant/colors.dart';
import 'package:rpcadvisorapp/global/globa_access_data.dart';
import 'package:rpcadvisorapp/widget/dialog/dialog.dart';
import 'package:rpcadvisorapp/widget/text/normal_text.dart';

class RemoveStudentFromSheet extends ConsumerStatefulWidget {
  final String? monitorId;
  const RemoveStudentFromSheet({super.key, this.monitorId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveStudentFromSheetState();
}

class _RemoveStudentFromSheetState
    extends ConsumerState<RemoveStudentFromSheet> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUser);
    final item = user.getmonitordetail(widget.monitorId);
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaQuery.of(context).size.width.horizontalSpace,
              GeneralSans(
                label: "Proponents:",
                fontColor: CustomColor.darkColor,
                fontSize: 26.sp,
              ),
              15.spMin.verticalSpace,
              user.returnModel(item.zCode).isEmpty
                  ? GeneralSans(
                      label: "No one joined yet.",
                      fontColor: CustomColor.darkColor,
                      fontSize: 14.sp,
                      medium: true,
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: user.returnModel(item.zCode).length,
                      itemBuilder: (context, index) {
                        final itemP = user.returnModel(item.zCode)[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            DialogCustom.dialogoption(
                                context: context,
                                yes: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  ref.read(currentUser.notifier).removeStudent(
                                        sheet: item,
                                        studentId: itemP.supabaseId,
                                        onSuccess: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          //context.pop();
                                        },
                                      );
                                },
                                no: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                message:
                                    "Are you sure want to delete this student ${"${itemP.firstName} ${itemP.lastName}"}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            child: Row(
                              children: [
                                GeneralSans(
                                  label: "${itemP.firstName} ${itemP.lastName}",
                                  fontColor: CustomColor.darkColor,
                                  fontSize: 14.sp,
                                  bold: true,
                                  align: TextAlign.left,
                                ),
                                Spacer(),
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: 30.spMin,
                                  color: CustomColor.kindaRed,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
