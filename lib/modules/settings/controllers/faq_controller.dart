import 'package:gorider/core/utils/exports.dart';

class FaqController extends GetxController {
  final profileService = serviceLocator<ProfileService>();
  final GetStorage getStorage = GetStorage();

  setSelectedFaq({required FaqDataModel faq}) {
    selectedFaq = faq;
    update();
  }

  bool fetchingFaqs = false;
  FaqDataModel? selectedFaq;
  List<FaqDataModel> faqs = [];

  getFaqs() async {
    fetchingFaqs = true;
    update();

    APIResponse response = await profileService.getFAQs();

    fetchingFaqs = false;
    update();

    if (response.status == "success") {
      faqs = (response.data['categories'] as List)
          .map((fq) => FaqDataModel.fromJson(fq))
          .toList();
      if (faqs.isNotEmpty) {
        setSelectedFaq(faq: faqs[0]);
      }
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }

  @override
  void onInit() async {
    await getFaqs();
    super.onInit();
  }
}
