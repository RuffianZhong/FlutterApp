import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../helper/image_helper.dart';
import '../../../res/color_res.dart';

List<String> imageUrl = [
  "https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=d57830e0ca280cc0f87fdbf10b25305b",
  "https://img2.baidu.com/it/u=2860188096,638334621&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=cc435e450717a2beb0623dd45752f75f",
  "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=1d3fe5d6db1996aa3b45c8636347869d",
  "https://img2.baidu.com/it/u=4244269751,4000533845&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=9e3bbec87e572ee9bf269a018c71e0ac",
  "https://img1.baidu.com/it/u=2029513305,2137933177&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=fc9d00fc14a8feeb19be958ba428ecba",
];

///内容Item
class ItemContentWidget extends StatefulWidget {
  final int index;

  const ItemContentWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<ItemContentWidget> createState() => _ItemContentWidgetState();
}

class _ItemContentWidgetState extends State<ItemContentWidget> {
  @override
  Widget build(BuildContext context) {
    return itemWidget(context, widget.index);
  }

  Widget itemWidget(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            ///顶部信息
            itemHeaderWidget(context, index),

            const SizedBox(height: 6),

            ///内容
            itemContentWidget(context, index),

            const SizedBox(height: 4),

            ///底部信息
            itemFooterWidget(context, index),

            ///分割线
            itemSeparatorWidget(),
          ],
        ));
  }

  Widget itemHeaderWidget(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //作者头像
        ClipOval(
          child: ImageHelper.load(imageUrl[index % 5], height: 45, width: 45),
        ),
        const SizedBox(width: 4),
        //作者昵称
        Expanded(
            child: Text(
          "作者名",
          maxLines: 1,
          style: TextStyle(fontSize: 14, color: ColorRes.tContentSub),
        )),
        const SizedBox(width: 4),
        //时间
        Text(
          "2022-20-20 12:22:22",
          style: TextStyle(fontSize: 14, color: ColorRes.tContentSub),
        ),
      ],
    );
  }

  Widget itemContentWidget(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///标题
            Text(
              "",
              style: TextStyle(fontSize: 18, color: ColorRes.tContentMain),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            ///副标题
            Offstage(
                offstage: index % 5 == 2,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 15, color: ColorRes.tContentSub),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        )),

        const SizedBox(width: 6),

        ///条件性展示控件
        Offstage(
            offstage: index % 5 == 2,
            child: ImageHelper.load(imageUrl[index % 5],
                height: 100, width: 70, fit: BoxFit.cover)),
      ],
    );
  }

  ///底部内容控件
  Widget itemFooterWidget(BuildContext context, int index) {
    return Row(
      children: [
        ///置顶标识
        Offstage(
            offstage: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                S.of(context).topping,
                style: TextStyle(fontSize: 12, color: ColorRes.themeMain),
              ),
              decoration:
                  BoxDecoration(border: Border.all(color: ColorRes.themeMain)),
            )),

        const SizedBox(width: 6),

        ///标签
        Expanded(
            child: Text(
          S.of(context).label_group("", ""),
          style: const TextStyle(fontSize: 14, color: ColorRes.tContentMain),
        )),

        ///收藏
        GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            )),
      ],
    );
  }

  ///item分割线
  Widget itemSeparatorWidget() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(top: 10),
      color: Colors.grey[300],
    );
  }
}
