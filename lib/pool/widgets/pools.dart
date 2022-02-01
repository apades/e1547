import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'tile.dart';

class PoolsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PoolsPageState();
  }
}

class _PoolsPageState extends State<PoolsPage> with ProviderCreatorMixin {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<Settings, Client, PoolController>(
      update: guard2(
        create: (context, value, value2) => PoolController(
          settings: value,
          client: value2,
        ),
        dispose: (context, value) => value.dispose,
      ),
      dispose: (context, value) => value.dispose,
      builder: (context, child) {
        PoolController controller = Provider.of<PoolController>(context);
        return RefreshableControllerPage(
          appBar: DefaultAppBar(
            title: Text('Pools'),
          ),
          floatingActionButton: SheetFloatingActionButton(
            actionIcon: Icons.search,
            builder: (context, actionController) => ControlledTextField(
              labelText: 'Pool title',
              actionController: actionController,
              textController:
                  TextEditingController(text: controller.search.value),
              submit: (value) => controller.search.value = value,
            ),
          ),
          drawer: NavigationDrawer(),
          controller: controller,
          builder: (context) => PagedListView(
            padding: defaultListPadding,
            pagingController: controller,
            builderDelegate: defaultPagedChildBuilderDelegate(
              pagingController: controller,
              itemBuilder: (context, Pool item, index) => PoolTile(
                pool: item,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PoolPage(pool: item),
                  ),
                ),
              ),
              onLoading: Text('Loading pools'),
              onEmpty: Text('No pools'),
              onError: Text('Failed to load pools'),
            ),
          ),
        );
      },
    );
  }
}
