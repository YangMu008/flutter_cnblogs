import 'package:flutter/material.dart';
import 'package:flutter_cnblogs/app/controller/base_controller.dart';
import 'package:flutter_cnblogs/widgets/status/app_empty_widget.dart';
import 'package:flutter_cnblogs/widgets/status/app_error_widget.dart';

import 'package:flutter_cnblogs/widgets/status/app_not_login_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class PageListView extends StatelessWidget {
  final BasePageController pageController;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsets? padding;
  final bool firstRefresh;
  final Function()? onLoginSuccess;
  const PageListView({
    required this.itemBuilder,
    required this.pageController,
    this.padding,
    this.firstRefresh = false,
    this.separatorBuilder,
    this.onLoginSuccess,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          EasyRefresh(
            header: MaterialHeader(
              completeDuration: const Duration(milliseconds: 400),
            ),
            footer: MaterialFooter(
              completeDuration: const Duration(milliseconds: 400),
            ),
            scrollController: pageController.scrollController,
            controller: pageController.easyRefreshController,
            firstRefresh: firstRefresh,
            onLoad: pageController.loadData,
            onRefresh: pageController.refreshData,
            child: ListView.separated(
              padding: padding,
              itemCount: pageController.list.length,
              itemBuilder: itemBuilder,
              separatorBuilder:
                  separatorBuilder ?? (context, i) => const SizedBox(),
            ),
          ),
          Offstage(
            offstage: !pageController.pageEmpty.value,
            child: AppEmptyWidget(
              onRefresh: () => pageController.refreshData(),
            ),
          ),
          Offstage(
            offstage: !pageController.pageError.value,
            child: AppErrorWidget(
              errorMsg: pageController.errorMsg.value,
              onRefresh: () => pageController.refreshData(),
            ),
          ),
          Offstage(
            offstage: !pageController.notLogin.value,
            child: AppNotLoginWidget(
              onLoginSuccess: onLoginSuccess,
            ),
          ),
        ],
      ),
    );
  }
}
