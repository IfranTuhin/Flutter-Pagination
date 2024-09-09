import 'package:get/get.dart';
import 'package:pagination_getx/service/api_service.dart';

class PaginationController extends GetxController {
  var dataList = <dynamic>[].obs;
  var isLoading = false.obs;
  var isMoreDataAvailable = true.obs;
  int start = 0;
  final int limit = 10;

  ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPaginatedData();
  }

  fetchPaginatedData() async {
    // Ensure data is fetched only when it's not currently loading
    if (isMoreDataAvailable.value && !isLoading.value) {
      isLoading.value = true;  // Start loading
      try {
        var fetchedData = await apiService.fetchData(start, limit);
        if (fetchedData.isNotEmpty) {
          dataList.addAll(fetchedData);  // Add new data to the list
          start += limit;  // Update start index for next fetch
        } else {
          isMoreDataAvailable.value = false;  // No more data to load
        }
      } catch (e) {
        isMoreDataAvailable.value = false;
      } finally {
        isLoading.value = false;  // Stop loading
      }
    }
  }

  void loadMoreData() {
    fetchPaginatedData();
  }
}
