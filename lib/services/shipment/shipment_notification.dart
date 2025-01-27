import 'dart:convert';
import 'dart:developer';

import 'package:go_logistics_driver/models/delivery_notification_model.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class ShipmentNotificationService extends GetxService {
  static ShipmentNotificationService get instance => Get.find();

  bool _isDialogShowing = false;
  bool _isListenerSetup = false;

  void initialize() {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().listenForShipments((data) {
        log("*********************************************New delivery******************************************************");
        log(data.toString());
        log("***************************************************************************************************");
        handleShipmentNotification(data);
      });
    }
  }

  void handleDialogDismissal() {
    if (_isDialogShowing) {
      _isDialogShowing = false;
    }
  }

  void setupShipmentListener() {
    if (_isListenerSetup) {
      log('Shipment listeners already setup, skipping');
      return;
    }

    final socketService = Get.find<SocketService>();

    // Setup shipment listener
    socketService.socket.on('shipment_events', (dynamic data) {
      log('Received shipment notification');
      log("**********************************************************************************");
      log(data.toString());
      log("Shipment Entered **********************************************************************************");
      handleShipmentNotification(data);
    });

    _isListenerSetup = true;
  }

  void handleShipmentNotification(dynamic data) {
    try {
      final parsedData = data is String ? jsonDecode(data) : data;
      final shipment = DeliveryNotificationModel.fromJson(parsedData);
      _isDialogShowing = false;
      if (!_isDialogShowing) {
        FlutterRingtonePlayer().playNotification();
        showShipmentDialog(shipment);
      }
    } catch (e) {
      log('Error handling shipment notification: $e');
    }
  }

  void showShipmentDialog(DeliveryNotificationModel shipment) {
    _isDialogShowing = true;

    Get.dialog(
      Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GetBuilder<OrdersController>(builder: (ordersController) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        'New Order Available!',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 20),
                      OrderDetailRow(
                        label: 'Distance:',
                        value: "${double.parse(shipment.distance).round()}km",
                      ),
                      OrderDetailRow(
                        label: 'Amount:',
                        value: formatToCurrency(double.parse(shipment.cost)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                Get.back();
                                _isDialogShowing = false;
                              },
                              title: "Reject",
                              backgroundColor: AppColors.redColor,
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: CustomButton(
                              onPressed: () async {
                                await ordersController.acceptDelivery(
                                  context,
                                  trackingId: shipment.trackingId,
                                );

                                if (ordersController.acceptedDelivery) {
                                  _isDialogShowing = false;
                                  Navigator.of(context).pop();
                                  Get.toNamed(Routes.ORDER_TRACKING_SCREEN);
                                  ordersController.fetchDeliveries();
                                  Get.find<LocationService>()
                                      .startEmittingParcelLocation(
                                          deliveryModel: ordersController
                                              .selectedDelivery!);
                                  ordersController
                                      .drawPolylineFromRiderToDestination(context,
                                          destinationPosition: LatLng(
                                              double.parse(ordersController
                                                  .selectedDelivery!
                                                  .originLocation
                                                  .latitude),
                                              double.parse(ordersController
                                                  .selectedDelivery!
                                                  .originLocation
                                                  .longitude)));
                                }
                              },
                              title: "Accept",
                              isBusy: ordersController.acceptingDelivery,
                              backgroundColor: AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      barrierDismissible: false,
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            label,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.montserrat().fontFamily!,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: customText(value,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.montserrat().fontFamily!),
          ),
        ],
      ),
    );
  }
}
