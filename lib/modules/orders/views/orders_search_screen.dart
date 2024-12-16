
import 'package:go_logistics_driver/utils/exports.dart';

class OrdersSearchScreen extends StatelessWidget {
  const OrdersSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Orders",
            implyLeading: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.h),
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  CustomOutlinedRoundedInputField(
                    label: "Enter tracking number e.g: Xd391B",
                    isSearch: true,
                    color: AppColors.obscureTextColor,
                    hasTitle: true,
                    prefixWidget: Container(
                        padding: EdgeInsets.all(12.sp),
                        child: SvgPicture.asset(
                          SvgAssets.searchIcon,
                        )),
                    suffixWidget: IconButton(
                      icon: const Icon(Icons.filter_list_alt),
                      onPressed: () {
                        showAnyBottomSheet(child: const SearchFilterBottomSheet(),isControlled: true);
                      },
                    ),
                    // controller: signInProvider.emailController,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  const SectionHeader(
                    title: "Search results",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ...List.generate(
                    14,
                        (i) =>  OrderItemWidget(status: i%2==0?"Delivered":"Pending",),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
