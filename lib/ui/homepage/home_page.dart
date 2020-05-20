import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobfinderapp01/data/homepage/Jobs.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_presenter.dart';
import 'package:jobfinderapp01/ui/homepage/home_page_view.dart';

class HomePage extends StatefulWidget {
  final HomePagePresenter presenter;
  HomePage(this.presenter, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomePageView {
  Widget _homePageWidget = _buildInitialLoadingWidget();
  final providerController = new TextEditingController();
  final positionController = new TextEditingController();
  final locationController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this.widget.presenter.attachView(this);
    this.widget.presenter.fetchJobList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Job Finder App"),
        leading: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.search),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildFilterPopUp(context),
            );
          },
        ),
      ),
      body: _homePageWidget,
    );
  }

  @override
  onDataFetchFailWidget() {
    setState(() {
      _homePageWidget = new Text(
        "Failed To Fetch Data...",
        style: new TextStyle(fontSize: 18.0),
      );
    });
  }

  @override
  onDataFetchedWidget(List<Jobs> jobList) {
    setState(() {
      _homePageWidget = _buildListViewWidget(jobList);
    });
  }

  @override
  onFilteredWidget(List<Jobs> filteredJobList) {
    setState(() {
      _homePageWidget = _buildListViewWidget(filteredJobList);
    });
  }

  Widget _buildFilterPopUp(context) {
    return new AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: const Text("Search by"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200,
        width: 200,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Provider"),
                controller: providerController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Position"),
                controller: positionController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Location"),
                controller: locationController,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[

        FlatButton(
            onPressed: () {
              _buildFilteredListViewWidget();
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.search))
      ],
    );
  }

  ListView _buildListViewWidget(List<Jobs> jobList) {
    return new ListView.builder(
        itemCount: jobList.length,
        itemBuilder: (context, i) {
          return new Column(children: <Widget>[
            new ListTile(
              leading: CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: jobList[i].companyLogo,
                placeholder: (context, url) => new Image(
                    width: 100,
                    height: 100,
                    image: AssetImage("assets/loading.png")),
                errorWidget: (context, url, error) => new Image(
                    width: 100,
                    height: 100,
                    image: AssetImage("assets/loading.png")),
              ),
              title: Text(jobList[i].title),
              subtitle: Text(jobList[i].companyName +
                  ', ' +
                  jobList[i].location +
                  ', ' +
                  jobList[i].createdDate),
              //                  trailing: Divider(), // side arrow
              isThreeLine: true,
              onTap: () {
                this.widget.presenter.goToDetailsUrl(jobList[i].jobDetailUrl);
              },
            ),
            new Divider(
              height: 20.0,
            )
          ]);
        });
  }

  static Center _buildInitialLoadingWidget() {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// Loader Animation Widget
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Text("Loading..."),
        ],
      ),
    );
  }

  void _buildFilteredListViewWidget() {
    this.widget.presenter.buildListViewWithFilteredJobList(
        providerController.text, positionController.text,
        locationController.text);
  }
}
