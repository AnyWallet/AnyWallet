import 'package:foss_wallet/src/screens/settings/widgets/settings_cell_with_arrow.dart';
import 'package:foss_wallet/utils/show_pop_up.dart';
import 'package:foss_wallet/view_model/dashboard/dashboard_view_model.dart';
import 'package:cw_core/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:foss_wallet/routes.dart';
import 'package:foss_wallet/generated/i18n.dart';
import 'package:foss_wallet/src/screens/base_page.dart';
import 'package:foss_wallet/src/screens/nodes/widgets/node_list_row.dart';
import 'package:foss_wallet/src/widgets/standard_list.dart';
import 'package:foss_wallet/src/widgets/alert_with_two_actions.dart';
import 'package:foss_wallet/view_model/node_list/node_list_view_model.dart';

class ConnectionSyncPage extends BasePage {
  ConnectionSyncPage(this.nodeListViewModel, this.dashboardViewModel);

  @override
  String get title => S.current.connection_sync;

  final NodeListViewModel nodeListViewModel;
  final DashboardViewModel dashboardViewModel;

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsCellWithArrow(
            title: S.current.reconnect,
            handler: (context) => _presentReconnectAlert(context),
          ),
          StandardListSeparator(padding: EdgeInsets.symmetric(horizontal: 24)),
          if (dashboardViewModel.hasRescan)
            SettingsCellWithArrow(
              title: S.current.rescan,
              handler: (context) => Navigator.of(context).pushNamed(Routes.rescan),
            ),
          StandardListSeparator(padding: EdgeInsets.symmetric(horizontal: 24)),
          Semantics(
            button: true,
            child: NodeHeaderListRow(
              title: S.of(context).add_new_node,
              onTap: (_) async =>
                  await Navigator.of(context).pushNamed(Routes.newNode),
            ),
          ),
          StandardListSeparator(padding: EdgeInsets.symmetric(horizontal: 24)),
          SizedBox(height: 100),
          Observer(
            builder: (BuildContext context) {
              return Flexible(
                child: SectionStandardList(
                  sectionCount: 1,
                  context: context,
                  dividerPadding: EdgeInsets.symmetric(horizontal: 24),
                  itemCounter: (int sectionIndex) {
                    return nodeListViewModel.nodes.length;
                  },
                  itemBuilder: (_, sectionIndex, index) {
                    final node = nodeListViewModel.nodes[index];
                    final isSelected = node.keyIndex == nodeListViewModel.currentNode.keyIndex;
                    final nodeListRow = NodeListRow(
                      title: node.uriRaw,
                      node: node,
                      isSelected: isSelected,
                      onTap: (_) async {
                        if (isSelected) {
                          return;
                        }

                        await showPopUp<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertWithTwoActions(
                                alertTitle:
                                    S.of(context).change_current_node_title,
                                alertContent: nodeListViewModel
                                    .getAlertContent(node.uriRaw),
                                leftButtonText: S.of(context).cancel,
                                rightButtonText: S.of(context).change,
                                actionLeftButton: () =>
                                    Navigator.of(context).pop(),
                                actionRightButton: () async {
                                  await nodeListViewModel.setAsCurrent(node);
                                  Navigator.of(context).pop();
                                },
                              );
                            });
                      },
                    );

                    return nodeListRow;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _presentReconnectAlert(BuildContext context) async {
    await showPopUp<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertWithTwoActions(
            alertTitle: S.of(context).reconnection,
            alertContent: S.of(context).reconnect_alert_text,
            rightButtonText: S.of(context).ok,
            leftButtonText: S.of(context).cancel,
            actionRightButton: () async {
              Navigator.of(context).pop();
              await dashboardViewModel.reconnect();
            },
            actionLeftButton: () => Navigator.of(context).pop());
      },
    );
  }
}
