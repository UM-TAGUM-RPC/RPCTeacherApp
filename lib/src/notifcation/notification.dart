import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constant/constant.dart';

class NotifcationScreen extends ConsumerStatefulWidget {
  const NotifcationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotifcationScreenState();
}

class _NotifcationScreenState extends ConsumerState<NotifcationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColor.whiteF7,
    );
  }
}
