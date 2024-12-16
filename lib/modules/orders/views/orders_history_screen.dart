
import 'package:go_logistics_driver/modules/orders/views/widgets/order_tab_chip.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,

            title: "Orders history",
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

                  CustomOutlinedClickableRoundedInputField(
                    label: "Enter tracking number e.g: Xd391B",
                    isSearch: true,
                    color: AppColors.obscureTextColor,
                    hasTitle: true,
                    onPressed: () {
                      Get.to(OrdersSearchScreen());
                    },
                    prefixWidget: Container(
                        padding: EdgeInsets.all(12.sp),
                        child: SvgPicture.asset(
                          SvgAssets.searchIcon,
                        )),
                    suffixWidget: IconButton(
                      icon: const Icon(Icons.filter_list_alt),
                      onPressed: () {
                        Get.to(OrdersSearchScreen());
                      },
                    ),
                    // controller: signInProvider.emailController,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(width: 1.sw,
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          OrderTabChip(onSelected: (){},title: "All",isSelected: true,),
                          OrderTabChip(onSelected: (){},title: "Pending",isSelected: false,),
                          OrderTabChip(onSelected: (){},title: "In transit",isSelected: false,),
                          OrderTabChip(onSelected: (){},title: "Delivered",isSelected: false,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
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
