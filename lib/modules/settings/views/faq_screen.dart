import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/settings/controllers/faq_controller.dart';
import 'package:gorider/modules/settings/views/widgets/faq_category_chip.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqController>(
      builder: (faqController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Faqs",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      ...List.generate(
                        faqController.faqs.length,
                        (i) => FaqCategoryChip(
                          value: faqController.faqs[i].name,
                          isSelected: faqController.faqs[i] == faqController.selectedFaq,
                          onSelected: () {
                            faqController.setSelectedFaq(
                              faq: faqController.faqs[i],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    mainAxisAlignment: faqController.fetchingFaqs
                        ? MainAxisAlignment.center
                        : (faqController.faqs.isNotEmpty
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center),
                    children: [
                      if (faqController.fetchingFaqs)
                        SkeletonLoaders.faqPage()
                      else if (faqController.faqs.isEmpty)
                        const Center(
                          child: Text(
                            "No FAQs available",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      else
                        ...List.generate(
                          faqController.selectedFaq?.faqs.length ?? 0,
                          (i) => FaqItemWidget(
                            question: faqController.selectedFaq?.faqs[i].question ?? "",
                            answer: faqController.selectedFaq?.faqs[i].answer ?? "",
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15.sp),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


