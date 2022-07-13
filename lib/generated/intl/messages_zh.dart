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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "clean_all": MessageLookupByLibrary.simpleMessage("清除全部"),
        "collect": MessageLookupByLibrary.simpleMessage("收藏"),
        "color_theme": MessageLookupByLibrary.simpleMessage("彩色主题"),
        "dark_style": MessageLookupByLibrary.simpleMessage("暗黑模式"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "integral": m0,
        "label_group": m1,
        "loading_content": MessageLookupByLibrary.simpleMessage("内容加载中..."),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "no_account": MessageLookupByLibrary.simpleMessage("还没账号？"),
        "placeholder": MessageLookupByLibrary.simpleMessage("--"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "register_now": MessageLookupByLibrary.simpleMessage("立即注册"),
        "search_hint": MessageLookupByLibrary.simpleMessage("用空格分隔多个关键词"),
        "search_hot_title": MessageLookupByLibrary.simpleMessage("热门搜索"),
        "search_local_title": MessageLookupByLibrary.simpleMessage("历史搜索"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "tab_home": MessageLookupByLibrary.simpleMessage("首页"),
        "tab_me": MessageLookupByLibrary.simpleMessage("我的"),
        "tab_project": MessageLookupByLibrary.simpleMessage("项目"),
        "tab_square": MessageLookupByLibrary.simpleMessage("广场"),
        "tab_wechat": MessageLookupByLibrary.simpleMessage("公众号"),
        "topping": MessageLookupByLibrary.simpleMessage("置顶"),
        "user_name": MessageLookupByLibrary.simpleMessage("用户名"),
        "user_psw": MessageLookupByLibrary.simpleMessage("密码"),
        "user_psw_confirm": MessageLookupByLibrary.simpleMessage("确认密码")
      };
}
