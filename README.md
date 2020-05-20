# Job Finder App

It is a job search solution mobile application. It looks into several providers and displays the aggregated result.
Currently, it aggregates from 2 providers. i.e. Github and Local Static Data. The app is developed in Flutter so
basically, every component is a widget so the whole application is a widget tree.

## Getting Started

This project is a Flutter application so in order to get a copy of the project and run on your local machine for
development/testing there are some prerequisits and installation steps to be followed.

### Prerequisites

* Flutter must be installed (for reference : https://flutter.dev/docs/get-started/install)
* A text editor [Android Studio Preferred] must be setup (for reference : https://flutter.dev/docs/get-started/editor)

### Project Installation
After installing Flutter and setting up a text editor
* Clone the project from git repo

* ```
  git clone https://github.com/amanandhargithub04/jobFinderApp01.git
  ```
* After successfully pulled from git repo open the project in the text editor
* Before running the application, make sure a virtual android device is configured and running

* ```
  For example : Testing was done in "Pixel 2 API 28"

  for reference on how to configure your virtual android devide please refer : https://developer.android.com/studio/run/managing-avds
  ```
* Once all above steps are carried out successfully, you can run the app either from text editor or terminal

* ```
  To run from Terminal, go to projecct directory and run the command : flutter run
  ```

##Folder Structure
### top-level directory layout

    .
    ├── android                 # Source files for android
    ├── assets                  # Files include default logo and local json data
    ├── build                   # Compiled files
    ├── ios                     # Source files for ios
    ├── lib                     # Dart files (This is the main directory where we write our source code)
    ├── test                    # Automated tests
    ├── pubspec.yaml            # Configuration file for our application (here we define dependencies, environment specific configurations, etc)
    └── README.md

### lib directory layout
This is where we write our main source code

    .
        ├── ...
        ├── lib
        │   ├── data                                 # Models responsible for data related operations
        │   │    ├── homepage                        # Models responsible for homepage data
        │   │    │    ├── Jobs.dart                  # Pojo Class for data fetched
        │   │    ├── network                         # Helpers responsible for data fetching
        │   │        ├── ApiHelper.dart              # Responsible for data fetching from API
        │   │        ├── AssetHelper.dart            # Responsible for fetching local data
        │   ├── ui                                   # Views and Presnter
        │   │    ├── base                            # Base class
        │   │    │    ├── base_presenter.dart        # Base presenter class
        │   │    ├── homepage                        # Implementing classes
        │   │        ├── home_page.dart              # Statefull HomePage widget
        │   │        ├── home_page_presenter.dart    # Responsible to manipulate logical operations for HomePage widget
        │   │        ├── home_page_view.dart         # Abstract view class defining operations for HomePage widget
        │   ├── utils                                # Util classes
        │   │    ├── key_mapping_util.dart           # Provides provider specific map alon with their data sctucures
        │   │    ├── text_helper.dart                # Checks if a string is not null nor empty
        │   └── main.dart                            # This is the main file which is served when our application runs
        └── ...

### test directory layout
This is where we store our test files

    .
        ├── ...
        ├── test
        │    ├── home_page_presenter_test.dart  #This test file covers almost all the methods inside HomePagePresenter
        │
        └── ...


## Application UI Details
After running the application successfully you will see :
* "Job Finder App" in the AppBar
* A Search Icon leading in the AppBar
* Loading Circular Progress Indicator at the center until data us fetched from APIs
* List view of fetched job lists including
    * Company logo (if not available default logo from assets)
    * Job Title
    * Company Name
    * Location
    * Postdate
* If user clicks on any one of the jobs then he/she will be redirected to JobDetailUrl in a browser
* If user clicks on Search Icon on the AppBar a popup panel will appear containing
    * Provider
    * Position
    * Location
* User can filter jobs using these fields in any combination and filtered result will be displayed

## Code execution flow
#### Code execution cycle to display fetched job list :
When the application runs, Main.dart file is served
* It builds a StatelessWidget and sets HomePage widget in the 'home' parameter
* A new instance of the HomePagePresenter is passed as the argument of HomePage widget
* Which is registered as the current presenter for that widget
* The current view (i.e. HomePageView) is attached to the presenter so that it can perform logical operations for that view
* After that fetchJobList() of HomePagePresenter is triggered in order to fetch the data from APIs
* Mean while the main view/widget is built with a loading circular progress indicator in the body
* In background inside HomePagePresenter.fetchJobLit() asynchronous operation is being carried out
* First it checks if a view is attached in order to proceed with data fetching
* Then gets the providers map from KeyMappingUril and iterates over each of them to perform data fetch for each of them
* While iterating if the provider contains "Local" keyword then
    * performs async call AssetHelper().parseJsonFromAssets([asset path mentioned in the keymapping])
    * after getting JSON String successfully, calls createJobListFromJsonString(..) to decode and populate "_fetchedJobList"
    * Then onDataFetchedWidget([with fetchedJobList]) is called which invokes setState({}) in HomePage and the widget is rebuild with list of fetched jobs

* In the else condition (i.e. for other external providers)
    * performs async call ApiHelper().fetchJobs([host url mentioned in the keymapping])
    * after getting Response from api, calls createJobListFromResponse(..)
    * If the status code is of group 2XX then decodes response body and populates "_fetchedJobList"
    * Then onDataFetchedWidget([with fetchedJobList]) is called which invokes setState({}) in HomePage and the widget is rebuild with list of fetched jobs
    * Else if checks "_fetchedJobList" is empty or not to make sure if other API calls have already populated the list
    * Finally if the "_fetchedJobList" is empty then onDataFetchFailWidget() is called to display a "Failed to Fetch Data..." text widget
    * This method call invokes setState({}) in HomePage which rebuilds the widget with error message.

#### Code execution cycle to display a filtered job list :
Once all the fetched job list are displayed successfully
* When a user clicks on the FloatingActionButton(..Search Icon..)
* _buildFilterPopUp(context) is called to display an AlertDialog(..)
* Which contains 3 text fields for filtering the list
* Provider, Position, Location and each of the fields are bind to their respective controllers
* When the user types filter text in any of the text fields and clicks on FlatButton(..Search Icon..) at the bottom of AlertDialog(..)
* _buildFilteredListViewWidget() is called which again passes the filter operation to HomePagePresenter.buildListViewWithFilteredJobList(..)
* In the presenter filtered texts are passed as arguments with the help of respective controllers
* Filtering action is performed in the "_fetchedJobList" which was populated during data fetch
* List is iterated and for each Job we get filter condition (i.e. call getFilterCondition([with job],..,..,..))
    * Each of the filter texts are checked TextHelper.isNotNullNorEmpty(..)
    * If it returns true then we add convert the respective fields to lowerCase and compare
    * and the result is added in a conditions list
    * finally after all filter texts are checked and conditions added
    * a condition is returned by ANDing each of the conditions

* Then onDataFetchedWidget([with filteredJobList]) is called which invokes setState({}) in HomePage and the widget is rebuild with list of filtered jobs

## Enhancements
#### To add new providers
In near future if any new providers are to be added then
* Go to utils -> key_mappgin_util.dart
* Create a static method returning HashMap
* Similar to getDefaultResponseKeyMapping() for external provider and similar to getLocalStorageResponseKeyMapping() for local
* In that HashMap mention the respective host_url(for external) / asset_path(for local) and api response data structure
* Then in getProviderMap() add a new entry in "providerMap"
* where key => "New Provider Name", value => "HashMap created for new provider"
* ```
  For example : providerMap["GitHub"] = getDefaultResponseKeyMapping();
  ```
* Then once you reload the app the newly added provider entry will be iterated in HomePagePresenter and data will be displayed in the UI
* To verify the jobs can be filtered from newly added provider name

##### Note :
* Even if newly added API only fails to load data the UI will not be disrupted
* The data will be displayed from other successful API calls
* Also if the new API response structure is different and proper Jobs mapping fails
* There is default implementation of "N/A" for the string fields and default loginLogo.png for company logo
* Hence the UI will not be disrupted and corrections can be made for response fields in key_mappgin_util.dart file.