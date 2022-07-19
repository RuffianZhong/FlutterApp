import 'package:flutter/material.dart';
import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';

///
/// 数据转换逻辑参考 generated > json > base > json_convert_content.dart
///
/// 在没有实现动态处理 _convertFuncMap 和 _getListChildType 之前，直接使用该文件的功能
///

/// json 数据转换实现原理
///
/// 1.手动编写实体类，并编写数据转换逻辑
/// 借助官方 dart:convert库，通过 json.decode() 方法将 string 类型的数据转为 Map 数据结构：Map<String, dynamic>，再通过 map[key] 取数据
/*class Ip {
  String origin;

  Ip(this.origin);

  Ip.fromJson(Map<String, dynamic> json) : origin = json['origin'];

  Map<String, dynamic> toJson() => {
        "origin": origin,
      };
}*/

///
/// 2.json_serializable 是dart官方推荐和提供的JSON转Model的方式
/// 2.1添加依赖
/// dependencies:
///   json_annotation: ^4.4.0
///
/// dev_dependencies:
///   build_runner: ^2.0.0
///   json_serializable: ^6.0.0
///
/// 2.2 添加 model

/*part 'user.g.dart'; ///自动生成，但是需要先手动引入

@JsonSerializable()
class User {
  String name;
  String email;
  @JsonKey(name: "register_date")
  String registerDate;
  List<String> courses;
  Computer computer;

  User(this.name, this.email, this.registerDate, this.courses, this.computer);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{name: $name, email: $email, registerDate: $registerDate, courses: $courses, computer: $computer}';
  }

}

part 'computer.g.dart';

@JsonSerializable()
class Computer {
  String brand;
  double price;

  Computer(this.brand, this.price);

  factory Computer.fromJson(Map<String, dynamic> json) => _$ComputerFromJson(json);
  Map<String, dynamic> toJson() => _$ComputerToJson(this);

  @override
  String toString() {
    return 'Computer{brand: $brand, price: $price}';
  }
}*/

///
///
/// 2.3 生成代码：flutter pub run build_runner build
///
///
/// 3. 编辑器插件 FlutterJsonBeanFactory
///
///
