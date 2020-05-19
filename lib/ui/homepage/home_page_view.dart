
import 'package:jobfinderapp01/data/homepage/Jobs.dart';

abstract class HomePageView {
  onDataFetchedWidget(List<Jobs> jobList);

  onDataFetchFailWidget();

  onFilteredWidget(List<Jobs> filteredJobList);
}
