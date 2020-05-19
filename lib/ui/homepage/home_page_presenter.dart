import 'dart:collection';
import 'dart:convert';
import 'package:jobfinderapp01/data/homepage/Jobs.dart';
import 'package:jobfinderapp01/data/network/ApiHelper.dart';
import 'package:jobfinderapp01/data/network/AssetsHelper.dart';
import 'package:jobfinderapp01/ui/base/base_presentor.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_view.dart';
import 'package:jobfinderapp01/utils/key_mapping_util.dart';
import 'package:jobfinderapp01/utils/text_helper.dart';

class HomePagePresenter extends BasePresenter<HomePageView> {
  List<Jobs> _fetchedJobList = new List<Jobs>();

  Future fetchJobList() async {
    checkViewAttached();

    KeyMappingUtil.getProviderMap().forEach((key, value) async {
      if (key.contains("Local")) {
        //fetch local json data
        String localJsonString = await new AssetsHelper()
            .parseJsonFromAssets(value[Keys.assets_path]);
        createJobListFromJsonString(
            key, localJsonString, _fetchedJobList, value);
      } else {
        //fetch data from external provider
        var response = await new ApiHelper().fetchJobs(value[Keys.host_url]);
        createJobListFromResponse(key, response, _fetchedJobList, value);
      }
    });
  }

  /*
  * For local data fetch
  */
  Future createJobListFromJsonString(String provider, String jsonString,
      List<Jobs> fetchedJobList, HashMap map) async {
    decodeAndAddToList(provider, jsonString, fetchedJobList, map);
    isViewAttached ? getView().onDataFetchedWidget(fetchedJobList) : null;
  }

  /*
  * for external data fetch
  */
  void createJobListFromResponse(
      String provider, response, List<Jobs> fetchedJobList, HashMap map) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      decodeAndAddToList(provider, response.body, fetchedJobList, map);
      isViewAttached ? getView().onDataFetchedWidget(fetchedJobList) : null;
    } else if (fetchedJobList.isEmpty) {
      getView().onDataFetchFailWidget();
    }
  }

  void decodeAndAddToList(String provider, String responseString,
      List<Jobs> fetchedJobList, HashMap keyMapping) {
    fetchedJobList.addAll((json.decode(responseString) as List)
        .map((json) => Jobs.fromJson(provider, json, keyMapping))
        .toList());
  }

  void buildListViewWithFilteredJobList(
      String provider, String position, String location) {
    List<Jobs> filteredJobList = _fetchedJobList
        .where((job) => getFilterCondition(job, provider, position, location))
        .toList();
    isViewAttached ? getView().onFilteredWidget(filteredJobList) : null;
  }

  bool getFilterCondition(
      Jobs job, String provider, String position, String location) {
    List<bool> conditions = new List<bool>();

    if (TextHelper.isNotNullNorEmpty(provider)) {
      conditions.add(job.provider
          .toLowerCase()
          .contains(provider.toLowerCase()));
    }

    if (TextHelper.isNotNullNorEmpty(position)) {
      conditions.add(job.title
          .toLowerCase()
          .contains(position.toLowerCase()));
    }

    if (TextHelper.isNotNullNorEmpty(location)) {
      conditions.add(job.location
          .toLowerCase()
          .contains(location.toLowerCase()));
    }

    bool retCondition = true;
    conditions.forEach((condition) {
      retCondition = retCondition && condition;
    });

    return retCondition;
  }

  void goToDetailsUrl(String jobDetailUrl) {
    new ApiHelper().goToDetailsUrl(jobDetailUrl);
  }
}
