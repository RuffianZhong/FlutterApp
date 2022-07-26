import 'package:flutter/material.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/utils/string_util.dart';

import '../../../config/router_config.dart';
import '../../../generated/l10n.dart';
import '../../../helper/image_helper.dart';

///文章Item控件
class ItemArticleWidget extends StatefulWidget {
  final ArticleEntity article;

  ///收藏事件回调
  GestureTapCallback? onTapCollect;

  ItemArticleWidget({Key? key, required this.article, this.onTapCollect})
      : super(key: key);

  @override
  State<ItemArticleWidget> createState() => _ItemArticleWidgetState();
}

class _ItemArticleWidgetState extends State<ItemArticleWidget> {
  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    if (widget.article.isTop != null && widget.article.isTop == true) {
      bgColor = Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withOpacity(0.2)
          : Theme.of(context).primaryColor.withOpacity(0.1);
    }
    return Container(
        color: bgColor,
        child: GestureDetector(
          onTap: () => actionItemClick(),
          child: itemWidget(context, widget.article),
        ));
  }

  void actionItemClick() {
    RouterHelper.pushNamed(context, RouterConfig.articleDetailsPage,
        arguments: widget.article);
  }

  Widget itemWidget(BuildContext context, ArticleEntity article) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            ///顶部信息
            itemHeaderWidget(context, article),

            const SizedBox(height: 6),

            ///内容
            itemContentWidget(context, article),

            const SizedBox(height: 4),

            ///底部信息
            itemFooterWidget(context, article),

            ///分割线
            itemSeparatorWidget(),
          ],
        ));
  }

  Widget itemHeaderWidget(BuildContext context, ArticleEntity article) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //作者头像
        ClipOval(
          child: ImageHelper.network(article.userIcon ?? "",
              height: 40, width: 40),
        ),
        const SizedBox(width: 4),
        //作者昵称
        Expanded(
            child: Text(
          article.userName ?? "",
          maxLines: 1,
          style: Theme.of(context).textTheme.labelMedium,
        )),
        const SizedBox(width: 4),
        //时间
        Text(
          article.date ?? "",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget itemContentWidget(BuildContext context, ArticleEntity article) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///标题
            //Html(data: article.title ?? ""),
            Text(
              StringUtil.removeHtmlLabel(article.title ?? ""),
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            ///副标题
            Offstage(
                offstage: article.desc?.isEmpty ?? true,
                child: Text(
                  StringUtil.removeHtmlLabel(article.desc ?? ""),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        )),

        const SizedBox(width: 6),

        ///条件性展示控件
        Offstage(
            offstage: article.cover?.isEmpty ?? true,
            child: ImageHelper.network(article.cover ?? "",
                height: 100, width: 70, fit: BoxFit.cover)),
      ],
    );
  }

  ///底部内容控件
  Widget itemFooterWidget(BuildContext context, ArticleEntity article) {
    IconData icon = Icons.favorite_border;
    if (article.collect != null) {
      icon = article.collect! ? Icons.favorite : Icons.favorite_border;
    }
    return Row(
      children: [
        ///置顶标识
        Offstage(
            offstage: !(article.isTop ?? false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: Text(
                S.of(context).topping,
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            )),

        Offstage(
          offstage: !(article.isTop ?? false),
          child: const SizedBox(width: 6),
        ),

        ///标签
        Expanded(
            child: Text(
          S.of(context).label_group(
              article.superChapterName ?? "", article.chapterName ?? ""),
          style: Theme.of(context).textTheme.labelMedium,
        )),

        ///收藏
        GestureDetector(
          onTap: widget.onTapCollect,
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  ///item分割线
  Widget itemSeparatorWidget() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(top: 10),
      color: Theme.of(context).dividerColor,
    );
  }
}
