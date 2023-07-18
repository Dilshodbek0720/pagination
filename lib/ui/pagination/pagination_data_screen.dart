import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n8_default_project/data/local/db/local_database.dart';
import 'package:n8_default_project/data/models/google_search_model.dart';
import 'package:n8_default_project/data/models/organic_model.dart';
import 'package:n8_default_project/data/models/universal_data.dart';
import 'package:n8_default_project/data/network/api_provider.dart';
import 'package:n8_default_project/utils/icons.dart';

import '../../utils/colors.dart';

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
  int selectedMenu = 1;

  List<OrganicModel> organicModels = [];

  List<ModelSql> texts = [];
  String text = "";


  insertText({required String name})async{
    await LocalDatabase.insertContact(ModelSql(name: name));
    setState(() {  });
  }

  getAllTexts()async{
    texts = await LocalDatabase.getAllContacts();
    setState(() {  });
  }


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
      if(currentPage==1){
        insertText(name: queryController.text);
        getAllTexts();
      }
      setState(() {});
    }
    currentPage++;
  }

  @override
  void initState() {
    getAllTexts();
    print(texts.length);
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
        centerTitle: true,
        leading: PopupMenuButton<int>(
          icon: SvgPicture.asset(AppImages.burger),
          onSelected: (v){
            {
              setState(() {
                selectedMenu = v;
              });
              if (selectedMenu == 3) {
                  countOfPage = 20;
              } else {
                if(selectedMenu == 2){
                    countOfPage = 10;
                }else{
                    countOfPage = 5;
                }
              }
              _fetchResult();
            }
          },
          // offset: Offset(-50, 0),
          position: PopupMenuPosition.values.first,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 1,
              height: 30,
              child: Text('5'),
            ),
            const PopupMenuItem<int>(
              value: 2,
              height: 30,
              child: Text('10'),
            ),
            const PopupMenuItem<int>(
              value: 3,
              height: 30,
              child: Text('20'),
            ),
          ],
        ),
        title:SizedBox(width: 92,height: 32, child: Image.asset(AppImages.google),),
        actions: [
          SizedBox(height: 32, width: 32, child: Image.asset(AppImages.profile),),
          SizedBox(width: 16,)
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 42,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: TextField(
              onChanged: (v) {
                queryText = v;
              },
              maxLines: 1,
              onSubmitted: (v) {
                setState(() {
                  organicModels = [];
                  currentPage = 1;
                });
                _fetchResult();
              },
              controller: queryController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                prefixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      organicModels = [];
                      currentPage = 1;
                    });
                    _fetchResult();
                  },
                    child: Container(margin: EdgeInsets.all(11), child: SvgPicture.asset(AppImages.search),)),
                suffixIcon: GestureDetector(
                  onTap: (){
                    queryController.clear();
                  },
                    child: Container(margin: EdgeInsets.all(11), child: SvgPicture.asset(AppImages.close),)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.C_E0E0E0,
                        width: 1,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppColors.C_E0E0E0,
                        width: 1,
                      ))),
            ),
          ),
          Container(
            height: 45,
            width: double.infinity,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(texts.length, (index) => TextButton(
                  onPressed: (){
                    setState(() {
                      queryController.text = texts[texts.length - index- 1].name;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Text(texts[texts.length - index- 1].name),
                  ),
                ))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Divider(height: 2, color: Colors.black.withOpacity(0.08),),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                ...List.generate(organicModels.length, (index) {
                  OrganicModel organicModel = organicModels[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(organicModel.link,
                                maxLines: 1,
                                style: TextStyle(
                                fontSize: 13
                              ),),
                              SizedBox(height: 6,),
                              Text(organicModel.title,
                                maxLines: 2,
                                style: TextStyle(
                                fontSize: 21,
                                color: Colors.blue,
                              ),),
                              Text(
                                organicModel.snippet,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                ),
                              ),
                              Text(organicModel.date),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(height: 5, color: AppColors.C_E0E0E0.withOpacity(0.8),),
                        )
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
