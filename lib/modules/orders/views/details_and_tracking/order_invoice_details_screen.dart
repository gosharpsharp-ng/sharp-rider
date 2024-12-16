import 'package:go_logistics_driver/utils/exports.dart';

class OrderInvoiceDetailsScreen extends StatelessWidget {
  const OrderInvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Invoice",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(children: const [
                    OrderInvoiceSummaryItem(
                      title: "Item name",
                      value: "Books",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Item category",
                      value: "Educational",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Weight",
                      value: "25 kg",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Shipping Fee",
                      value: "N1,000",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Tracking number",
                      value: "ZFD233435756",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Payment Method",
                      value: "GoWallet",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Date",
                      value: "Thu. Dec 5, 2024 7:15am",
                    ),
                    OrderInvoiceSummaryStatusItem(
                      title: "Status",
                      value: "Delivered",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Contact",
                      value: "08162848289",
                    ),
                  ]),
                  SectionBox(children: const [
                    OrderInvoiceSummaryItem(
                      title: "Sender's Name",
                      value: "Ayodeji Sebanjo",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Phone Number",
                      value: "08162848289",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Email",
                      value: "ayounie@gmail.com",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Address",
                      isVertical: true,
                      value:
                          "Shop 7, Alaba international market, Alaba market Lagos.",
                    ),
                  ]),
                  SectionBox(children: const [
                    OrderInvoiceSummaryItem(
                      title: "Receiver's Name",
                      value: "Maloung Doe",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Phone Number",
                      value: "08036322653",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Email",
                      value: "emekaleingo@gmail.com",
                    ),
                    OrderInvoiceSummaryItem(
                      title: "Address",
                      isVertical: true,
                      value:
                          "Shop 7, Alaba international market, Alaba market Lagos.",
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
