import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:together/controllers/data_controller.dart';
import 'package:together/widget/data_card.dart';

class V1 extends StatefulWidget {
  const V1({super.key});

  @override
  State<V1> createState() => _V1State();
}

class _V1State extends State<V1> {
  late final StreamSubscription _connectivitySub;
  int page = 1;
  bool isLoading = true;
  bool noConnection = true;
  late final ScrollController _scrollController = ScrollController();
  late final DataController _dataController = DataController();

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
          title: const Text('Err'),
          content: Text(res.msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
      floatingActionButton: noConnection
          ? null
          : FloatingActionButton(
              onPressed: () => _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn),
              child: const Icon(Icons.arrow_upward_rounded),
            ),
      body: noConnection
          ? const Center(
              child: Text('No Internet connection'),
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _dataController.data.length + 1,
                  itemBuilder: (_, index) {
                    if (index != _dataController.data.length) {
                      return Center(
                        child: SplitCard(
                          dataModel: _dataController.data[index],
                        ),
                      );
                    } else {
                      return _dataController.listEnd
                          ? const Center(
                              child: Text('-----  End of List  -----'))
                          : const Center(child: CircularProgressIndicator());
                    }
                  }),
    );
  }
}
