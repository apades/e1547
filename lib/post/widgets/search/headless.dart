import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PostsPageHeadless extends StatelessWidget {
  const PostsPageHeadless();

  @override
  Widget build(BuildContext context) {
    PostController controller = Provider.of<PostController>(context);
    return TileLayoutScope(
      tileBuilder: defaultStaggerTileBuilder(
        (index) {
          PostFile image = controller.itemList![index].sample;
          return Size(image.width.toDouble(), image.height.toDouble());
        },
      ),
      builder: (context, crossAxisCount, tileBuilder) => PagedStaggeredGridView(
        key: joinKeys(['posts', crossAxisCount]),
        physics: BouncingScrollPhysics(),
        showNewPageErrorIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        padding: defaultListPadding,
        addAutomaticKeepAlives: false,
        pagingController: controller,
        builderDelegate: defaultPagedChildBuilderDelegate<Post>(
          pagingController: controller,
          onEmpty: Text('No posts'),
          onLoading: Text('Loading posts'),
          onError: Text('Failed to load posts'),
          itemBuilder: (context, item, index) => PostTile(
            post: item,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailGallery(
                    controller: controller,
                    initialPage: index,
                  ),
                ),
              );
            },
          ),
        ),
        gridDelegateBuilder: (childCount) =>
            SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          staggeredTileBuilder: tileBuilder,
          crossAxisCount: crossAxisCount,
          staggeredTileCount: controller.itemList?.length,
        ),
      ),
    );
  }
}
