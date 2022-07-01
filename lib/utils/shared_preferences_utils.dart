/// shared_preferences 工具类
class SPUtils {
  /// 静态变量指向自身
  static final SPUtils _instance = SPUtils._();

  /// 私有构造器
  SPUtils._(){

  }

  /// 方案1：静态方法获得实例变量
  static SPUtils getInstance() => _instance;

  /// 方案2：工厂构造方法获得实例变量(不能异步)
  //factory SPUtils() => _instance;

  /// 方案3：静态属性获得实例变量
  //static SPUtils get instance => _instance;







}
