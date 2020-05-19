import 'package:flutter/services.dart';

class AssetsHelper {
  Future parseJsonFromAssets(String assetsPath) async {
    return await rootBundle.loadString(assetsPath);
  }
}
