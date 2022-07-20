import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/hero_config.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';

import '../../../helper/router_helper.dart';

///预览界面
class PreviewPage extends StatefulWidget {
  final String imageUrl;

  const PreviewPage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: HeroConfig.tagPreview,
      child: GestureDetector(
        onTap: () => RouterHelper.pop(context),
        child: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: ImageHelper.network(widget.imageUrl,
              width: double.infinity, fit: BoxFit.fitWidth),
        ),
      ),
    );
  }
}
