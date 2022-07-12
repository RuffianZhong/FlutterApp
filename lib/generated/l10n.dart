// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `首页`
  String get tab_home {
    return Intl.message(
      '首页',
      name: 'tab_home',
      desc: '',
      args: [],
    );
  }

  /// `项目`
  String get tab_project {
    return Intl.message(
      '项目',
      name: 'tab_project',
      desc: '',
      args: [],
    );
  }

  /// `公众号`
  String get tab_wechat {
    return Intl.message(
      '公众号',
      name: 'tab_wechat',
      desc: '',
      args: [],
    );
  }

  /// `广场`
  String get tab_square {
    return Intl.message(
      '广场',
      name: 'tab_square',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get tab_me {
    return Intl.message(
      '我的',
      name: 'tab_me',
      desc: '',
      args: [],
    );
  }

  /// `积分：{value}`
  String integral(Object value) {
    return Intl.message(
      '积分：$value',
      name: 'integral',
      desc: '',
      args: [value],
    );
  }

  /// `收藏`
  String get collect {
    return Intl.message(
      '收藏',
      name: 'collect',
      desc: '',
      args: [],
    );
  }

  /// `暗黑模式`
  String get dark_style {
    return Intl.message(
      '暗黑模式',
      name: 'dark_style',
      desc: '',
      args: [],
    );
  }

  /// `彩色主题`
  String get color_theme {
    return Intl.message(
      '彩色主题',
      name: 'color_theme',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settings {
    return Intl.message(
      '设置',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `--`
  String get placeholder {
    return Intl.message(
      '--',
      name: 'placeholder',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get login {
    return Intl.message(
      '登录',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `注册`
  String get register {
    return Intl.message(
      '注册',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `立即注册`
  String get register_now {
    return Intl.message(
      '立即注册',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `还没账号？`
  String get no_account {
    return Intl.message(
      '还没账号？',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  /// `用户名`
  String get user_name {
    return Intl.message(
      '用户名',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get user_psw {
    return Intl.message(
      '密码',
      name: 'user_psw',
      desc: '',
      args: [],
    );
  }

  /// `确认密码`
  String get user_psw_confirm {
    return Intl.message(
      '确认密码',
      name: 'user_psw_confirm',
      desc: '',
      args: [],
    );
  }

  /// `置顶`
  String get topping {
    return Intl.message(
      '置顶',
      name: 'topping',
      desc: '',
      args: [],
    );
  }

  /// `{main} - {sub}`
  String label_group(Object main, Object sub) {
    return Intl.message(
      '$main - $sub',
      name: 'label_group',
      desc: '',
      args: [main, sub],
    );
  }

  /// `用空格分隔多个关键词`
  String get search_hint {
    return Intl.message(
      '用空格分隔多个关键词',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `热门搜索`
  String get search_hot_title {
    return Intl.message(
      '热门搜索',
      name: 'search_hot_title',
      desc: '',
      args: [],
    );
  }

  /// `历史搜索`
  String get search_local_title {
    return Intl.message(
      '历史搜索',
      name: 'search_local_title',
      desc: '',
      args: [],
    );
  }

  /// `编辑`
  String get edit {
    return Intl.message(
      '编辑',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `清除全部`
  String get clean_all {
    return Intl.message(
      '清除全部',
      name: 'clean_all',
      desc: '',
      args: [],
    );
  }

  /// `完成`
  String get done {
    return Intl.message(
      '完成',
      name: 'done',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
