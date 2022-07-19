import '../../generated/json/base/json_convert_content.dart';

///网络请求结果
class HttpResult<T> {
  late int code;
  String? msg;

  ///解析成为实体类使用：与 list 互斥
  T? data;

  ///解析成为列表使用：与 data 互斥
  List<T>? list;

  HttpResult();

  ///业务逻辑是否成功
  bool get success => code == 0;

  HttpResult<T> convert(Map<String, dynamic> json) {
    HttpResult<T> entity = HttpResult<T>();

    /// 业务逻辑的 data
    dynamic data = json['data'];

    /// 业务逻辑的 code
    int code = json['errorCode'];

    /// 业务逻辑的 msg
    String? msg = json['errorMsg'];

    /// 解析成为 List
    if (data is List) {
      entity.list = _convertList(data);
    } else {
      entity.data = _convertData(data);
    }

    entity.code = code;
    entity.msg = msg;
    return entity;
  }

  ///转为List
  List<T> _convertList(dynamic data) {
    List<T> list = [];
    for (var item in data) {
      list.add(jsonConvert.convert<T>(item) as T);
    }
    return list;
  }

  ///转为具体数据
  T? _convertData(dynamic data) {
    return jsonConvert.convert<T>(data);
  }
}
