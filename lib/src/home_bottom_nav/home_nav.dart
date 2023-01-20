import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  Widget build(BuildContext context) {
    final index = ref.watch(navSelection);
    return Scaffold(
      backgroundColor: CustomColor.white,
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
                showBadge: true,
              ),
            ],
          ),
        ],
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
      default:
    }
  }
}
