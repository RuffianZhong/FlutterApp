import '../../generated/json/base/json_convert_content.dart';

///网络请求结果
///泛型是最终实体类型，如果想要 List<T> 只需要指定 T 然后获取 list 对应的值即可
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
      entity.list = convertList(data);
    } else {
      entity.data = convertData(data);
    }

    entity.code = code;
    entity.msg = msg;
    return entity;
  }

  ///转为List
  List<T> convertList(dynamic data) {
    List<T> list = [];
    for (var item in data) {
      list.add(jsonConvert.convert<T>(item) as T);
    }
    return list;
  }

  ///转为具体数据
  T? convertData(dynamic data) {
    return jsonConvert.convert<T>(data);
  }
}
