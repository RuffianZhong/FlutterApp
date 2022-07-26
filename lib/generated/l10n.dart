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

  /// `Home`
  String get tab_home {
    return Intl.message(
      'Home',
      name: 'tab_home',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get tab_project {
    return Intl.message(
      'Project',
      name: 'tab_project',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge`
  String get tab_knowledge {
    return Intl.message(
      'Knowledge',
      name: 'tab_knowledge',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get tab_book {
    return Intl.message(
      'Book',
      name: 'tab_book',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get tab_me {
    return Intl.message(
      'Me',
      name: 'tab_me',
      desc: '',
      args: [],
    );
  }

  /// `Integral：{value}`
  String integral(Object value) {
    return Intl.message(
      'Integral：$value',
      name: 'integral',
      desc: '',
      args: [value],
    );
  }

  /// `Collect`
  String get collect {
    return Intl.message(
      'Collect',
      name: 'collect',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_style {
    return Intl.message(
      'Dark Mode',
      name: 'dark_style',
      desc: '',
      args: [],
    );
  }

  /// `Color Theme`
  String get color_theme {
    return Intl.message(
      'Color Theme',
      name: 'color_theme',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
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

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get register_now {
    return Intl.message(
      'Register now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `No account yet？`
  String get no_account {
    return Intl.message(
      'No account yet？',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get user_name {
    return Intl.message(
      'UserName',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get user_psw {
    return Intl.message(
      'Password',
      name: 'user_psw',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get user_psw_confirm {
    return Intl.message(
      'Confirm Password',
      name: 'user_psw_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Topping`
  String get topping {
    return Intl.message(
      'Topping',
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

  /// `separate multiple keywords with spaces`
  String get search_hint {
    return Intl.message(
      'separate multiple keywords with spaces',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Popular search`
  String get search_hot_title {
    return Intl.message(
      'Popular search',
      name: 'search_hot_title',
      desc: '',
      args: [],
    );
  }

  /// `Historical search`
  String get search_local_title {
    return Intl.message(
      'Historical search',
      name: 'search_local_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Clear all`
  String get clean_all {
    return Intl.message(
      'Clear all',
      name: 'clean_all',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `content loading...`
  String get loading_content {
    return Intl.message(
      'content loading...',
      name: 'loading_content',
      desc: '',
      args: [],
    );
  }

  /// `Learned{progress}%`
  String learn_progress(Object progress) {
    return Intl.message(
      'Learned$progress%',
      name: 'learn_progress',
      desc: '',
      args: [progress],
    );
  }

  /// `No learned`
  String get learn_no {
    return Intl.message(
      'No learned',
      name: 'learn_no',
      desc: '',
      args: [],
    );
  }

  /// `Multi language`
  String get multi_language {
    return Intl.message(
      'Multi language',
      name: 'multi_language',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get language_chinese {
    return Intl.message(
      'Chinese',
      name: 'language_chinese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an account`
  String get account_empty_tip {
    return Intl.message(
      'Please enter an account',
      name: 'account_empty_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an password`
  String get psw_empty_tip {
    return Intl.message(
      'Please enter an password',
      name: 'psw_empty_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the password`
  String get psw_confirm_empty_tip {
    return Intl.message(
      'Please confirm the password',
      name: 'psw_confirm_empty_tip',
      desc: '',
      args: [],
    );
  }

  /// `Two passwords are inconsistent`
  String get psw_confirm_tip {
    return Intl.message(
      'Two passwords are inconsistent',
      name: 'psw_confirm_tip',
      desc: '',
      args: [],
    );
  }

  /// `Login success`
  String get login_success {
    return Intl.message(
      'Login success',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  /// `Register success`
  String get register_success {
    return Intl.message(
      'Register success',
      name: 'register_success',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get net_error {
    return Intl.message(
      'Network error',
      name: 'net_error',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get tab_tree {
    return Intl.message(
      'System',
      name: 'tab_tree',
      desc: '',
      args: [],
    );
  }

  /// `Navigation`
  String get tab_nav {
    return Intl.message(
      'Navigation',
      name: 'tab_nav',
      desc: '',
      args: [],
    );
  }

  /// `Book tutorial`
  String get tab_book_course {
    return Intl.message(
      'Book tutorial',
      name: 'tab_book_course',
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
