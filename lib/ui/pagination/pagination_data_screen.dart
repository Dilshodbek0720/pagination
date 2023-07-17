import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/google_search_model.dart';
import 'package:n8_default_project/data/models/organic_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';

class PaginationDataScreen extends StatefulWidget {
  const PaginationDataScreen({Key? key}) : super(key: key);

  @override
  State<PaginationDataScreen> createState() => _PaginationDataScreenState();
}

class _PaginationDataScreenState extends State<PaginationDataScreen> {
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int countOfPage = 5;
  String queryText = "";
  bool isLoading = false;

  List<OrganicModel> organicModels = [];

  _fetchResult() async {
    setState(() {
      isLoading = true;
    });
    UniversalData universalData = await ApiProvider.searchFromGoogle(
      query: queryText,
      page: currentPage,
      count: countOfPage,
    );

    setState(() {
      isLoading = false;
    });

    if (universalData.error.isEmpty) {
      GoogleSearchModel googleSearchModel =
          universalData.data as GoogleSearchModel;
      organicModels.addAll(googleSearchModel.organicModels);
      setState(() {});
    }
    currentPage++;
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _fetchResult();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) {
                queryText = v;
              },
              onSubmitted: (v) {
                setState(() {
                  organicModels = [];
                  currentPage = 1;
                });
                _fetchResult();
              },
              controller: queryController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ))),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                ...List.generate(organicModels.length, (index) {
                  OrganicModel organicModel = organicModels[index];
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16)),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(organicModel.title),
                        Text(organicModel.snippet),
                        Text(
                          organicModel.link,
                          maxLines: 1,
                        ),
                        Text(organicModel.date),
                      ],
                    ),
                  );
                }),
                Visibility(
                  visible: isLoading,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
