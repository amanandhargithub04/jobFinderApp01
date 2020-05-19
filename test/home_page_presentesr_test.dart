import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:jobfinderapp01/data/homepage/Jobs.dart';
import 'package:jobfinderapp01/data/network/ApiHelper.dart';
import 'package:jobfinderapp01/data/network/AssetsHelper.dart';
import 'package:jobfinderapp01/ui/homepage/home_page.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_presenter.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_view.dart';
import 'package:jobfinderapp01/utils/key_mapping_util.dart';
import 'package:mockito/mockito.dart';

void main() {
  HomePagePresenter mockPresenter;
  List<Jobs> mockJobList;
  String mockProvider = "MockProvider";
  Widget mockHomePageWidget;
  HashMap mockKeyMapping = KeyMappingUtil.getLocalStorageResponseKeyMapping();

  setUp(() {
    mockPresenter = new HomePagePresenter();
    mockJobList = new List<Jobs>();

    mockHomePageWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new HomePage(mockPresenter)));
  });

  test(
      "getFilterCondition() returns true if one of the filter matches and the rest are empty",
      () {
    mockJobList.addAll((json.decode(getStringForArrayOfJsonObjects()) as List)
        .map((json) => Jobs.fromJson(mockProvider, json, mockKeyMapping))
        .toList());
    bool actualCondition =
        mockPresenter.getFilterCondition(mockJobList[0], mockProvider, "", "");
    expect(actualCondition, true);
  });

  test(
      "getFilterCondition() returns true if two of the filters match and one is empty",
      () {
    mockJobList.addAll((json.decode(getStringForArrayOfJsonObjects()) as List)
        .map((json) => Jobs.fromJson(mockProvider, json, mockKeyMapping))
        .toList());
    bool actualCondition = mockPresenter.getFilterCondition(
        mockJobList[0], mockProvider, "Senior Software Engineer", "");
    expect(actualCondition, true);
  });

  test(
      "getFilterCondition() returns false even if two of the filters match and one does not",
      () {
    mockJobList.addAll((json.decode(getStringForArrayOfJsonObjects()) as List)
        .map((json) => Jobs.fromJson(mockProvider, json, mockKeyMapping))
        .toList());
    bool actualCondition = mockPresenter.getFilterCondition(mockJobList[0],
        mockProvider, "Senior Software Engineer", "Not Matching Location");
    expect(actualCondition, false);
  });

  test(
      "decodeAndAddToList() decodes the responseString and populates in List of Jobs",
      () {
    List<Jobs> expectedJobList = new List<Jobs>();
    expectedJobList.addAll(
        (json.decode(getStringForArrayOfJsonObjects()) as List)
            .map((json) => Jobs.fromJson(mockProvider, json, mockKeyMapping))
            .toList());

    mockPresenter.decodeAndAddToList(mockProvider,
        getStringForArrayOfJsonObjects(), mockJobList, mockKeyMapping);
    expect(mockJobList[0].id, expectedJobList[0].id);
    expect(mockJobList[0].provider, expectedJobList[0].provider);
    expect(mockJobList[0].title, expectedJobList[0].title);
    expect(mockJobList[0].location, expectedJobList[0].location);
    expect(mockJobList[0].companyName, expectedJobList[0].companyName);
    expect(mockJobList[0].companyLogo, expectedJobList[0].companyLogo);
    expect(identical(mockJobList[0], expectedJobList[0]), false);
  });

  test(
      "decodeAndAddToList() fails if the responseString is not a valid decodable json string",
      () {
    expect(
        () => mockPresenter.decodeAndAddToList(mockProvider,
            "{Not Decodable JSON String}", mockJobList, mockKeyMapping),
        throwsFormatException);
  });

  test(
      "fetchJobList() fails if a view is not attached to the HomePagePresenter",
      () async {
    expect(() => mockPresenter.fetchJobList(), throwsException);
  });

  testWidgets(
      'createJobListFromResponse() method will load a "Failed to Fetch Data..." text if API fetch fails ',
      (WidgetTester tester) async {
    //Build Main Home Page widget
    await tester.pumpWidget(mockHomePageWidget);

    //Assert that Loading text is displayed until data is fetched from API
    final loadingText = find.text("Loading...");
    expect(loadingText, findsOneWidget);

    //Try to create job list with error response statusCode
    Response mockResponse = new Response("body", 400);
    mockPresenter.createJobListFromResponse(
        mockProvider, mockResponse, mockJobList, mockKeyMapping);

    //Rebuild the widget so that setStatus takes effect to load failed text
    await tester.pump(Duration.zero);
    final failedTextFinder = find.text("Failed To Fetch Data...");
    expect(failedTextFinder, findsOneWidget);
  });

  testWidgets(
      'createJobListFromResponse() method will display the fetched data in main widget ',
      (WidgetTester tester) async {
    //Build Main Home Page widget
    await tester.pumpWidget(mockHomePageWidget);

    //Assert that Loading text is displayed until data is fetched from API
    final loadingText = find.text("Loading...");
    expect(loadingText, findsOneWidget);

    //Try to create job list with success response statusCode
    Response mockResponse = new Response(getStringForArrayOfJsonObjects(), 200);
    mockPresenter.createJobListFromResponse(
        mockProvider, mockResponse, mockJobList, mockKeyMapping);

    //Rebuild the widget so that setStatus takes effect to load failed text
    await tester.pump(Duration.zero);

    //Assert there is no Failed to Fetch text after data is fetched from API
    final failedTextFinder = find.text("Failed To Fetch Data...");
    expect(failedTextFinder, findsNothing);

    //Assert that the title fetched from API is displayed in the Main View
    final listViewWidget = find.text(mockJobList[0].title);
    expect(listViewWidget, findsOneWidget);
  });

  testWidgets(
      'createJobListFromJsonString() method will display locally fetched data in main widget ',
      (WidgetTester tester) async {
    //Build Main Home Page widget
    await tester.pumpWidget(mockHomePageWidget);

    //Assert that Loading text is displayed until data is fetched from API
    final loadingText = find.text("Loading...");
    expect(loadingText, findsOneWidget);

    //Try to create job list from locally fetched jsonString
    mockPresenter.createJobListFromJsonString(mockProvider,
        getStringForArrayOfJsonObjects(), mockJobList, mockKeyMapping);

    //Rebuild the widget so that setStatus takes effect to load failed text
    await tester.pump(Duration.zero);

    //Assert there is no Failed to Fetch text after data is fetched from API
    final failedTextFinder = find.text("Failed To Fetch Data...");
    expect(failedTextFinder, findsNothing);

    //Assert that the title fetched from API is displayed in the Main View
    final listViewWidget = find.text(mockJobList[0].title);
    expect(listViewWidget, findsOneWidget);
  });

  testWidgets(
      'createJobListFromJsonString() method will load a default Job if unable to fetch local data ',
      (WidgetTester tester) async {
    //Build Main Home Page widget
    await tester.pumpWidget(mockHomePageWidget);

    //Assert that Loading text is displayed until data is fetched from API
    final loadingText = find.text("Loading...");
    expect(loadingText, findsOneWidget);

    //Try to create job list with empty json object string
    mockPresenter.createJobListFromJsonString(
        mockProvider, "[{}]", mockJobList, mockKeyMapping);

    //Rebuild the widget so that setStatus takes effect to load failed text
    await tester.pump(Duration.zero);

    final defaultJobTextFinder = find.text(mockJobList[0].title);
    expect(defaultJobTextFinder, findsOneWidget);
  });

  tearDown(() {
    mockPresenter = null;
    mockJobList = null;
    mockHomePageWidget = null;
  });
}

String getStringForArrayOfJsonObjects() {
  return "[{\"id\":\"6072588f-76e1-44db-9013-ece50994502b\",\"type_local\":\"Full Time\",\"url\":\"https:\/\/localhost\/positions\/6072588f-76e1-44db-9013-ece50994502b\",\"created_at\":\"Thu May 14 10:13:06 UTC 2020\",\"company_local\":\"Coolblue\",\"company_url\":\"http:\/\/careersatcoolblue.com\",\"location\":\"Rotterdam, The Netherlands\",\"title_local\":\"Senior Software Engineer\",\"company_logo\":\"https:\/\/jobs.github.com\/rails\/active_storage\/blobs\/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBa3FEIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--552356f7578f2e1177388c4b0df135242d29640b\/Coolblue%20logo.jpg\"}]";
}
