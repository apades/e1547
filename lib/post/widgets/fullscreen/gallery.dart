import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PostFullscreenGallery extends StatefulWidget {
  final int initialPage;
  final PostController controller;
  final Function(int index)? onPageChanged;

  const PostFullscreenGallery({
    required this.controller,
    this.initialPage = 0,
    this.onPageChanged,
  });

  @override
  _PostFullscreenGalleryState createState() => _PostFullscreenGalleryState();
}

class _PostFullscreenGalleryState extends State<PostFullscreenGallery>
    with RouteAware {
  late NavigationController navigationController;
  late PageController pageController =
      PageController(initialPage: widget.initialPage);
  late ValueNotifier<int> current = ValueNotifier(widget.initialPage);
  late FrameController frameController;

  Future<void> toggleFrame(bool shown) async {
    if (shown) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationController = Provider.of<NavigationController>(context);
    navigationController.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
    if (Provider.of<Settings>(context).hideSystemUI.value) {
      toggleFrame(false);
      frameController = FrameController(onToggle: toggleFrame);
      SystemChrome.setSystemUIChangeCallback((hidden) async {
        frameController.toggleFrame(shown: !hidden);
      });
    } else {
      frameController = FrameController();
    }
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIChangeCallback(null);
    navigationController.routeObserver.unsubscribe(this);
    frameController.dispose();
    super.dispose();
  }

  @override
  void didPop() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: current,
      builder: (context, int value, child) => Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: defaultUIStyle(Theme.of(context)).copyWith(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.black26,
            ),
          ),
        ),
        child: widget.controller.itemList != null
            ? PostFullscreenFrame(
                child: child!,
                post: widget.controller.itemList![value],
                controller: frameController,
              )
            : SizedBox.shrink(),
      ),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) => PageView.builder(
          itemCount: widget.controller.itemList?.length,
          controller: pageController,
          itemBuilder: (context, index) => PostFullscreenImageDisplay(
              post: widget.controller.itemList![index]),
          onPageChanged: (index) {
            current.value = index;
            widget.onPageChanged?.call(index);
            if (widget.controller.itemList != null) {
              preloadImages(
                context: context,
                index: index,
                posts: widget.controller.itemList!,
                size: ImageSize.file,
              );
            }
          },
        ),
      ),
    );
  }
}
