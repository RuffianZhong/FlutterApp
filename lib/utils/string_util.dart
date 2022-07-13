class StringUtil {
  ///移除html标签
  static String removeHtmlLabel(String data) {
    return data.replaceAll(RegExp('<[^>]+>'), '');
  }
}
