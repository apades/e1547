import 'package:e1547/follow/follow.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowsSplitPage extends StatefulWidget {
  @override
  _FollowsSplitPageState createState() => _FollowsSplitPageState();
}

class _FollowsSplitPageState extends State<FollowsSplitPage> {
  late RefreshController refreshController = RefreshController();
  late FollowUpdater followUpdater;

  Future<void> refreshFollows({bool force = false}) async {
    await followUpdater.update(force: force);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateRefresh() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (mounted) {
        if (refreshController.headerMode!.value == RefreshStatus.idle) {
          await refreshController.requestRefresh(
            needCallback: false,
            duration: Duration(milliseconds: 100),
          );
          await followUpdater.finish;
          ScrollController? scrollController =
              PrimaryScrollController.of(context);
          if (scrollController?.hasClients ?? false) {
            scrollController?.animateTo(
              0,
              duration: defaultAnimationDuration,
              curve: Curves.easeInOut,
            );
          }
          if (!followUpdater.error) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    followUpdater = Provider.of<FollowUpdater>(context);
    Future.delayed(Duration(milliseconds: 500), refreshFollows);
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return TileLayoutScope(
      tileBuilder: (tileHeightFactor, crossAxisCount, stagger) =>
          (index) => StaggeredTile.count(1, 1 * tileHeightFactor),
      builder: (context, crossAxisCount, tileBuilder) =>
          ValueListenableBuilder<List<Follow>>(
        valueListenable: settings.follows,
        builder: (context, follows, child) => ValueListenableBuilder<String>(
          valueListenable: settings.host,
          builder: (context, host, child) => AnimatedBuilder(
            animation: followUpdater,
            builder: (context, child) => RefreshablePageLoader(
              onEmpty: Text('No follows'),
              onLoading: Text('Loading follows'),
              onError: Text('Failed to load follows'),
              isError: false,
              isLoading: false,
              isEmpty: follows.isEmpty,
              refreshController: refreshController,
              refreshHeader: ValueListenableBuilder<int>(
                valueListenable: followUpdater.progress,
                builder: (context, progress, child) =>
                    RefreshablePageDefaultHeader(
                  refreshingText: 'Refreshing $progress / ${follows.length}...',
                ),
              ),
              builder: (context) => StaggeredGridView.countBuilder(
                key: joinKeys(['follows', tileBuilder, crossAxisCount]),
                padding: defaultListPadding,
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: false,
                crossAxisCount: crossAxisCount,
                itemCount: follows.length,
                itemBuilder: (context, index) =>
                    FollowTile(follow: follows[index], host: host),
                staggeredTileBuilder: tileBuilder,
              ),
              appBar: DefaultAppBar(
                title: Text('Following'),
                actions: [
                  ContextDrawerButton(),
                ],
              ),
              refresh: () async {
                if (await validateCall(() => refreshFollows(force: true))) {
                  refreshController.refreshCompleted();
                } else {
                  refreshController.refreshFailed();
                }
              },
              drawer: NavigationDrawer(),
              endDrawer: ContextDrawer(
                title: Text('Follows'),
                children: [
                  FollowSplitSwitchTile(),
                  FollowMarkReadTile(),
                  Divider(),
                  FollowSettingsTile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
