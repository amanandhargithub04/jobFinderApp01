import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ApiHelper {
  Future fetchJobs(String url) async {
    return await http.get(url);
  }

  void goToDetailsUrl(String jobDetailUrl) async {
    if (await canLaunch(jobDetailUrl)) {
      await launch(jobDetailUrl);
    } else {
      throw "Could Not launch $jobDetailUrl";
    }
  }
}