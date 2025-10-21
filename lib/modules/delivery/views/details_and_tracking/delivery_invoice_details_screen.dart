import 'package:gorider/core/utils/exports.dart';

class DeliveryInvoiceDetailsScreen extends StatelessWidget {
  const DeliveryInvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SectionBox(children: const [
                  DeliveryInvoiceSummaryItem(
                    title: "Item name",
                    value: "Books",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Item category",
                    value: "Educational",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Weight",
                    value: "25 kg",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Shipping Fee",
                    value: "N1,000",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Tracking number",
                    value: "ZFD233435756",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Payment Method",
                    value: "GoWallet",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Date",
                    value: "Thu. Dec 5, 2024 7:15am",
                  ),
                  OrderInvoiceSummaryStatusItem(
                    title: "Status",
                    value: "Delivered",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Contact",
                    value: "08162848289",
                  ),
                ]),
                SectionBox(children: const [
                  DeliveryInvoiceSummaryItem(
                    title: "Sender's Name",
                    value: "Ayodeji Sebanjo",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Phone Number",
                    value: "08162848289",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Email",
                    value: "ayounie@gmail.com",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Address",
                    isVertical: true,
                    value:
                        "Shop 7, Alaba international market, Alaba market Lagos.",
                  ),
                ]),
                SectionBox(children: const [
                  DeliveryInvoiceSummaryItem(
                    title: "Receiver's Name",
                    value: "Maloung Doe",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Phone Number",
                    value: "08036322653",
                  ),
                  DeliveryInvoiceSummaryItem(
                    title: "Email",
                    value: "emekaleingo@gmail.com",
                  ),
                  DeliveryInvoiceSummaryItem(
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
    });
  }
}
