// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(value) => "Integral：${value}";

  static String m1(main, sub) => "${main} - ${sub}";

  static String m2(progress) => "Learned${progress}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account_empty_tip":
            MessageLookupByLibrary.simpleMessage("Please enter an account"),
        "clean_all": MessageLookupByLibrary.simpleMessage("Clear all"),
        "collect": MessageLookupByLibrary.simpleMessage("Collect"),
        "color_theme": MessageLookupByLibrary.simpleMessage("Color Theme"),
        "dark_style": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "integral": m0,
        "label_group": m1,
        "language_chinese": MessageLookupByLibrary.simpleMessage("Chinese"),
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "learn_no": MessageLookupByLibrary.simpleMessage("No learned"),
        "learn_progress": m2,
        "loading_content":
            MessageLookupByLibrary.simpleMessage("content loading..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_success": MessageLookupByLibrary.simpleMessage("Login success"),
        "multi_language":
            MessageLookupByLibrary.simpleMessage("Multi language"),
        "net_error": MessageLookupByLibrary.simpleMessage("Network error"),
        "no_account": MessageLookupByLibrary.simpleMessage("No account yet？"),
        "placeholder": MessageLookupByLibrary.simpleMessage("--"),
        "psw_confirm_empty_tip":
            MessageLookupByLibrary.simpleMessage("Please confirm the password"),
        "psw_confirm_tip": MessageLookupByLibrary.simpleMessage(
            "Two passwords are inconsistent"),
        "psw_empty_tip":
            MessageLookupByLibrary.simpleMessage("Please enter an password"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "register_now": MessageLookupByLibrary.simpleMessage("Register now"),
        "register_success":
            MessageLookupByLibrary.simpleMessage("Register success"),
        "search_hint": MessageLookupByLibrary.simpleMessage(
            "separate multiple keywords with spaces"),
        "search_hot_title":
            MessageLookupByLibrary.simpleMessage("Popular search"),
        "search_local_title":
            MessageLookupByLibrary.simpleMessage("Historical search"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "tab_book": MessageLookupByLibrary.simpleMessage("Book"),
        "tab_book_course":
            MessageLookupByLibrary.simpleMessage("Book tutorial"),
        "tab_home": MessageLookupByLibrary.simpleMessage("Home"),
        "tab_knowledge": MessageLookupByLibrary.simpleMessage("Knowledge"),
        "tab_me": MessageLookupByLibrary.simpleMessage("Me"),
        "tab_nav": MessageLookupByLibrary.simpleMessage("Navigation"),
        "tab_project": MessageLookupByLibrary.simpleMessage("Project"),
        "tab_tree": MessageLookupByLibrary.simpleMessage("System"),
        "topping": MessageLookupByLibrary.simpleMessage("Topping"),
        "user_name": MessageLookupByLibrary.simpleMessage("UserName"),
        "user_psw": MessageLookupByLibrary.simpleMessage("Password"),
        "user_psw_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm Password")
      };
}
