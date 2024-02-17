import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:together/widget/data_card.dart';

import '../controllers/data_controller.dart';

class V2 extends StatefulWidget {
  const V2({super.key});

  @override
  State<V2> createState() => _V2State();
}

class _V2State extends State<V2> {
  int page = 1;
  bool isLoading = true;
  bool noConnection = true;
  late final ScrollController _scrollController = ScrollController();
  late final DataController _dataController = DataController();
  late final StreamSubscription _connectivitySub;

  @override
  void initState() {
    super.initState();

    // get internet connection when the screen loads
    checkConnection();

    // listen to any change in internet connection
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        noConnection = (result == ConnectivityResult.none);
      });

      if (!noConnection && _dataController.data.isEmpty) {
        page = 1;
        fetchData();
      }
    });

    _scrollController.addListener(() {
      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.offset) &&
          !_dataController.listEnd) {
        fetchData();
      }
    });

    // fetchData();
    //
    // _scrollController.addListener(() {
    //   if (_scrollController.position.maxScrollExtent ==
    //           _scrollController.offset &&
    //       !_dataController.listEnd) {
    //     fetchData();
    //   }
    // });
  }

  checkConnection() async {
    noConnection =
        (await Connectivity().checkConnectivity() == ConnectivityResult.none);

    setState(() {});
  }

  Future<void> fetchData() async {
    // log('here');
    var res = await _dataController.fetchData(pageKey: page++);

    // show dialog too the user if anything goes wrong
    if (!res.success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text('Err'),
          content: Text(res.msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    // log('updated');
    setState(() {
      isLoading = false;
    });
  }

  // Future fetchData() async {
  //   await _dataController.fetchData(pageKey: page++);
  //
  //   // log('Length - ' + _dataController.data.length.toString());
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();

    if (_connectivitySub != null) _connectivitySub.cancel();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery'),
      ),
      body: noConnection
          ? Center(
              child: Text('No Internet connection'),
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _dataController.data.length + 1,
                  itemBuilder: (_, index) {
                    if (index != _dataController.data.length) {
                      return Center(
                        child: GradientCard(
                          dataModel: _dataController.data[index],
                        ),
                      );
                    } else {
                      return _dataController.listEnd
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text('End of List'),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator());
                    }
                  }),
    );
  }
}
