import 'dart:collection';
import 'dart:convert';
import 'package:jobfinderapp01/utils/key_mapping_util.dart';

class Jobs {
  final String provider;
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String createdDate;
  final String companyUrl;
  final String companyLogo;
  final String jobDetailUrl;

  Jobs({this.provider, this.id, this.title, this.companyName, this.location, this.createdDate, this.companyUrl, this.companyLogo, this.jobDetailUrl});

  factory Jobs.fromJson(provider, json, HashMap keyMapping) {
    return Jobs(
        provider: provider,
        id: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.id]]),
        title: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.title]]),
        companyName: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.company]]),
        location: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.location]]),
        createdDate: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.created_at]]),
        companyUrl: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.company_url]]),
        companyLogo: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.company_logo]]),
        jobDetailUrl: getAlternativeIfNullOrEmpty(json[keyMapping[Keys.detailUrl]])
    );
  }

  static String getAlternativeIfNullOrEmpty(String jsonString) {
    return isNullOrEmpty(jsonString) ? "N/A" : jsonString;
  }

  static bool isNullOrEmpty(String jsonString) {
    return jsonString == null || jsonString == "";
  }

}