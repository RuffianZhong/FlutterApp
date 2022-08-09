// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(value) => "积分：${value}";

  static String m1(main, sub) => "${main} - ${sub}";

  static String m2(progress) => "已学${progress}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account_empty_tip": MessageLookupByLibrary.simpleMessage("请输入账号"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clean_all": MessageLookupByLibrary.simpleMessage("清除全部"),
        "collect": MessageLookupByLibrary.simpleMessage("收藏"),
        "collect_content": MessageLookupByLibrary.simpleMessage("您确定要移除收藏内容吗？"),
        "color_theme": MessageLookupByLibrary.simpleMessage("彩色主题"),
        "confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "dark_style": MessageLookupByLibrary.simpleMessage("暗黑模式"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "integral": m0,
        "label_group": m1,
        "language_chinese": MessageLookupByLibrary.simpleMessage("中文"),
        "language_english": MessageLookupByLibrary.simpleMessage("英文"),
        "learn_no": MessageLookupByLibrary.simpleMessage("未学习"),
        "learn_progress": m2,
        "loading_content": MessageLookupByLibrary.simpleMessage("内容加载中..."),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "login_success": MessageLookupByLibrary.simpleMessage("登录成功"),
        "multi_language": MessageLookupByLibrary.simpleMessage("多语言"),
        "net_error": MessageLookupByLibrary.simpleMessage("网络错误"),
        "no_account": MessageLookupByLibrary.simpleMessage("还没账号？"),
        "placeholder": MessageLookupByLibrary.simpleMessage("--"),
        "psw_confirm_empty_tip": MessageLookupByLibrary.simpleMessage("请确认密码"),
        "psw_confirm_tip": MessageLookupByLibrary.simpleMessage("两次密码不一致"),
        "psw_empty_tip": MessageLookupByLibrary.simpleMessage("请输入密码"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "register_now": MessageLookupByLibrary.simpleMessage("立即注册"),
        "register_success": MessageLookupByLibrary.simpleMessage("注册成功"),
        "search_hint": MessageLookupByLibrary.simpleMessage("用空格分隔多个关键词"),
        "search_hot_title": MessageLookupByLibrary.simpleMessage("热门搜索"),
        "search_local_title": MessageLookupByLibrary.simpleMessage("历史搜索"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "tab_book": MessageLookupByLibrary.simpleMessage("教程"),
        "tab_book_course": MessageLookupByLibrary.simpleMessage("书籍教程"),
        "tab_home": MessageLookupByLibrary.simpleMessage("首页"),
        "tab_knowledge": MessageLookupByLibrary.simpleMessage("知识"),
        "tab_me": MessageLookupByLibrary.simpleMessage("我的"),
        "tab_nav": MessageLookupByLibrary.simpleMessage("导航"),
        "tab_project": MessageLookupByLibrary.simpleMessage("项目"),
        "tab_tree": MessageLookupByLibrary.simpleMessage("体系"),
        "tips_msg": MessageLookupByLibrary.simpleMessage("提示"),
        "topping": MessageLookupByLibrary.simpleMessage("置顶"),
        "user_name": MessageLookupByLibrary.simpleMessage("用户名"),
        "user_psw": MessageLookupByLibrary.simpleMessage("密码"),
        "user_psw_confirm": MessageLookupByLibrary.simpleMessage("确认密码")
      };
}
