import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_getx/controller/pagination_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Pagination Controller
  final PaginationController paginationController =
      Get.put(PaginationController());

  // Scroll Controller
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    paginationController.fetchPaginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Trigger loading more data when reaching the bottom of the list
        paginationController.loadMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () {
              if (paginationController.isLoading.value &&
                  paginationController.dataList.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  controller: scrollController, // Assign the ScrollController
                  itemCount: paginationController.dataList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == paginationController.dataList.length) {
                      // Show loading indicator at the bottom while fetching more data
                      return paginationController.isMoreDataAvailable.value
                          ? const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(child: Text('No more data')),
                            );
                    }
                    var items = paginationController.dataList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: ListTile(
                        title: Text(
                          items['title'],
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          items['body'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
