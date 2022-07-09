import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:provider/provider.dart';

List<String> imageUrl = [
  "https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=d57830e0ca280cc0f87fdbf10b25305b",
  "https://img2.baidu.com/it/u=2860188096,638334621&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=cc435e450717a2beb0623dd45752f75f",
  "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=1d3fe5d6db1996aa3b45c8636347869d",
  "https://img2.baidu.com/it/u=4244269751,4000533845&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=9e3bbec87e572ee9bf269a018c71e0ac",
  "https://img1.baidu.com/it/u=2029513305,2137933177&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=fc9d00fc14a8feeb19be958ba428ecba",
  "https://img0.baidu.com/it/u=1694074520,2517635995&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657472400&t=3b8cee3f0f6a844e69f3b43dff3d8465"
];

class MainSquarePage extends StatefulWidget {
  const MainSquarePage({Key? key}) : super(key: key);

  @override
  State<MainSquarePage> createState() => _MainSquarePageState();
}

class _MainSquarePageState extends ZTLifecycleState<MainSquarePage>
    with AutomaticKeepAliveClientMixin, WidgetLifecycleObserver {
  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Logger.log("Square----build");
    return Scaffold(
        appBar: AppBar(
          title: Text("书籍教程"),
        ),
        body: bodyContent());
  }

  Widget bodyContent() {
    return Consumer<SquareViewModel>(builder: (context, viewModel, child) {
      return GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: viewModel.dataArray.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7),
          itemBuilder: (context, index) {
            return itemWidget(viewModel.dataArray[index]);
          });
    });
  }

  Widget itemWidget(BookEntity bookEntity) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ImageHelper.load(bookEntity.image, fit: BoxFit.cover));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      List<BookEntity> list = [];
      for (var image in imageUrl) {
        list.add(BookEntity(image));
      }

      Logger.log(list);
      SquareViewModel viewModel = context.read<SquareViewModel>();
      viewModel.dataArray = list;
    }
  }
}

class SquareViewModel extends ChangeNotifier {
  List<BookEntity> _dataArray = [];

  List<BookEntity> get dataArray => _dataArray;

  set dataArray(List<BookEntity> value) {
    _dataArray = value;
    notifyListeners();
  }
}

class BookEntity {
  String image;

  BookEntity(this.image);
}
