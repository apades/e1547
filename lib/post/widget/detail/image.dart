import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostDetailImage extends StatelessWidget {
  const PostDetailImage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PostImageWidget(
      post: post,
      size: PostImageSize.sample,
      fit: BoxFit.cover,
      lowResCacheSize: context.watch<ImageCacheSize?>()?.size,
    );
  }
}

class PostDetailVideo extends StatelessWidget {
  const PostDetailVideo({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    VideoPlayer player = post.getVideo(context)!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: () => player.state.playing ? player.pause() : player.play(),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          PostVideoWidget(post: post),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: VideoButton(player: player),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostDetailImageToggle extends StatelessWidget {
  const PostDetailImageToggle({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PostsConnector(
      post: post,
      builder: (context, post) {
        if (post.isDeleted) return const SizedBox.shrink();
        if (post.file == null) return const SizedBox.shrink();
        PostController controller = context.watch<PostController>();
        return CrossFade.builder(
          showChild:
              (!post.isFavorited && controller.isDenied(post)) ||
              controller.isAllowed(post),
          duration: const Duration(milliseconds: 200),
          builder: (context) => Card(
            color: controller.isAllowed(post)
                ? Colors.black12
                : Colors.transparent,
            elevation: 0,
            child: InkWell(
              onTap: () => controller.isAllowed(post)
                  ? controller.unallow(post)
                  : controller.allow(post),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Icon(
                        controller.isAllowed(post)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(controller.isAllowed(post) ? 'hide' : 'show'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PostDetailImageActions extends StatelessWidget {
  const PostDetailImageActions({
    super.key,
    required this.post,
    required this.child,
    this.onEnterVerticalFullscreen,
    this.onEnterHorizontalFullscreen,
  });

  final Post post;
  final Widget child;
  final VoidCallback? onEnterVerticalFullscreen;
  final VoidCallback? onEnterHorizontalFullscreen;

  @override
  Widget build(BuildContext context) {
    return PostsConnector(
      post: post,
      builder: (context, post) {
        VoidCallback? onFullscreenIconTap;

        PostController controller = context.watch<PostController>();
        bool visible =
            post.file != null &&
            (!controller.isDenied(post) || post.isFavorited);

        if (visible) {
          onFullscreenIconTap = post.type == PostType.unsupported
              ? () => launch(post.file!)
              : onEnterVerticalFullscreen;
        }

        Widget fullscreenButton() {
          if (post.type == PostType.video && onFullscreenIconTap != null) {
            return Row(
              children: [
                CrossFade.builder(
                  showChild: visible,
                  builder: (context) => Card(
                    elevation: 0,
                    color: Colors.black12,
                    child: InkWell(
                      onTap: onEnterHorizontalFullscreen,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.aspect_ratio,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                CrossFade.builder(
                  showChild: visible,
                  builder: (context) => Card(
                    elevation: 0,
                    color: Colors.black12,
                    child: InkWell(
                      onTap: onFullscreenIconTap,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.fullscreen,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        Widget muteButton() {
          return CrossFade.builder(
            showChild: post.type == PostType.video && post.file != null,
            builder: (context) => const Card(
              elevation: 0,
              color: Colors.black12,
              child: VideoServiceVolumeControl(),
            ),
          );
        }

        VideoPlayer? player = post.getVideo(context);

        return Stack(
          fit: StackFit.passthrough,
          children: [
            GestureDetector(
              onLongPressStart: (detail) {
                if (player == null) return;
                player.setRate(3);
              },
              onLongPressEnd: (detail) {
                if (player == null) return;
                player.setRate(1);
              },
              child: InkWell(
                hoverColor: Colors.transparent,
                onDoubleTap: () {
                  if (player == null) return;

                  player.state.playing ? player.pause() : player.play();
                },
                onTap: player != null ? () => {} : onFullscreenIconTap,
                child: child,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    muteButton(),
                    const Spacer(),
                    fullscreenButton(),
                    PostDetailImageToggle(post: post),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PostDetailImageDisplay extends StatelessWidget {
  const PostDetailImageDisplay({
    super.key,
    required this.post,
    this.onEnterVerticalFullscreen,
    this.onEnterHorizontalFullscreen,
  });

  final Post post;
  final VoidCallback? onEnterVerticalFullscreen;
  final VoidCallback? onEnterHorizontalFullscreen;

  @override
  Widget build(BuildContext context) {
    return PostDetailImageActions(
      onEnterVerticalFullscreen: onEnterVerticalFullscreen,
      onEnterHorizontalFullscreen: onEnterHorizontalFullscreen,
      post: post,
      child: PostImageOverlay(
        post: post,
        builder: (context) => Center(
          child: Hero(
            tag: post.link,
            child: ImageCacheSizeProvider(
              size: context.watch<ImageCacheSize?>()?.size,
              child: post.type == PostType.video
                  ? PostDetailVideo(post: post)
                  : PostDetailImage(post: post),
            ),
          ),
        ),
      ),
    );
  }
}
