import 'package:gorider/core/utils/exports.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmittingRequest = false;
  bool get isSubmittingRequest => _isSubmittingRequest;

  bool _fetchingPayouts = false;
  bool get fetchingPayouts => _fetchingPayouts;

  final String _payoutError = '';
  String get payoutError => _payoutError;
  bool get hasPayoutError => _payoutError.isNotEmpty;

  void setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  void setSubmittingState(bool val) {
    _isSubmittingRequest = val;
    update();
  }

  // Pagination for payout history
  final ScrollController payoutHistoryScrollController = ScrollController();
  int payoutPageSize = 15;
  int totalPayouts = 0;
  int currentPayoutPage = 1;
  List<PayoutRequest> payoutRequests = [];

  // Current selected payout
  PayoutRequest? selectedPayoutRequest;

  // Form data for creating payout requests
  final GlobalKey<FormState> payoutRequestFormKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  // Payment method is always 'bank'
  String selectedPaymentMethod = 'bank';

  // Wallet balance and limits
  double availableBalance = 0.0;
  double minimumPayoutAmount = 1000.0;
  double maximumPayoutAmount = 1000000.0;

  @override
  void onInit() {
    super.onInit();
    _payoutService.init();
    payoutHistoryScrollController.addListener(_payoutHistoryScrollListener);
  }

  @override
  void onReady() {
    super.onReady();
    getPayoutHistory();
    _loadBalanceFromDashboard();
  }

  @override
  void onClose() {
    payoutHistoryScrollController.removeListener(_payoutHistoryScrollListener);
    super.onClose();
  }

  // Scroll listener for pagination
  void _payoutHistoryScrollListener() {
    if (payoutHistoryScrollController.position.pixels >=
        payoutHistoryScrollController.position.maxScrollExtent - 100) {
      getPayoutHistory(isLoadMore: true);
    }
  }

  // Set selected payout request
  void setSelectedPayoutRequest(PayoutRequest payout) {
    selectedPayoutRequest = payout;
    update();
  }

  // Set payment method
  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    update();
  }

  // Load balance from settings controller (via rider wallet)
  void _loadBalanceFromDashboard() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        availableBalance =
            settingsController.userProfile?.wallet?.balanceDouble ?? 0.0;
        update();
      }
    } catch (e) {
      debugPrint("Error loading balance: $e");
    }
  }

  // Refresh balance (called after payout submission)
  Future<void> refreshBalance() async {
    if (Get.isRegistered<SettingsController>()) {
      final settingsController = Get.find<SettingsController>();
      await settingsController.getProfile();
      _loadBalanceFromDashboard();
    }
  }

  // Get payout history with pagination
  Future<void> getPayoutHistory({
    bool isLoadMore = false,
    String? status,
  }) async {
    if (_fetchingPayouts ||
        (isLoadMore && payoutRequests.length >= totalPayouts)) {
      return;
    }

    _fetchingPayouts = true;
    update();

    if (!isLoadMore) {
      payoutRequests.clear();
      currentPayoutPage = 1;
    }

    try {
      final response = await _payoutService.getPayoutHistory(
        page: currentPayoutPage,
        perPage: payoutPageSize,
        status: status,
      );

      _fetchingPayouts = false;

      if (response.status == "success" && response.data != null) {
        List<PayoutRequest> newPayouts = (response.data['data'] as List)
            .map((payout) => PayoutRequest.fromJson(payout))
            .toList();

        if (isLoadMore) {
          payoutRequests.addAll(newPayouts);
        } else {
          payoutRequests = newPayouts;
        }

        totalPayouts = response.data['total'] ?? 0;
        currentPayoutPage++;
        update();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      _fetchingPayouts = false;
      showToast(
        message: "Error loading payout history: ${e.toString()}",
        isError: true,
      );
      update();
    }
  }

  // Submit payout request
  Future<void> submitPayoutRequest() async {
    if (!payoutRequestFormKey.currentState!.validate()) return;

    final amount = stripCurrencyFormat(amountController.text);

    // Validate amount
    if (amount < minimumPayoutAmount) {
      // showToast(message: "Minimum payout amount is ${formatToCurrency(minimumPayoutAmount)}", isError: true);
      showWarningSheet(
        title: "Minimum Amount",
        message: "Minimum payout amount is ${formatToCurrency(minimumPayoutAmount)}",
      );
      return;
    }

    if (amount > maximumPayoutAmount) {
      // showToast(message: "Maximum payout amount is ${formatToCurrency(maximumPayoutAmount)}", isError: true);
      showWarningSheet(
        title: "Maximum Amount",
        message: "Maximum payout amount is ${formatToCurrency(maximumPayoutAmount)}",
      );
      return;
    }

    if (amount > availableBalance) {
      // showToast(message: "Insufficient balance", isError: true);
      showWarningSheet(
        title: "Insufficient Balance",
        message: "You don't have enough balance for this payout request.",
      );
      return;
    }

    setSubmittingState(true);

    try {
      final requestData = PayoutRequestData(
        amount: amount,
        paymentMethod: selectedPaymentMethod,
      );

      final response = await _payoutService.createPayoutRequest(
        requestData.toJson(),
      );

      if (response.status == "success") {
        // showToast(message: response.message, isError: false);

        // Update available balance from response if provided
        if (response.data != null &&
            response.data['available_balance'] != null) {
          availableBalance =
              double.tryParse(response.data['available_balance'].toString()) ??
                  availableBalance;
        }

        // Clear form
        amountController.clear();
        selectedPaymentMethod = 'bank';

        // Refresh data
        getPayoutHistory();
        refreshBalance();

        // Navigate back
        Get.back();
        showSuccessSheet(
          title: "Payout Requested",
          message: response.message,
        );
      } else {
        // showToast(message: response.message, isError: true);
        showErrorSheet(
          title: "Request Failed",
          message: response.message,
        );
      }
    } catch (e) {
      // showToast(message: "Error submitting payout request: ${e.toString()}", isError: true);
      showErrorSheet(
        title: "Error",
        message: "Error submitting payout request: ${e.toString()}",
      );
    } finally {
      setSubmittingState(false);
    }
  }

  // Get payout request details
  Future<void> getPayoutRequestDetails(int payoutId) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.getPayoutRequestDetails(payoutId);

      if (response.status == "success" && response.data != null) {
        selectedPayoutRequest = PayoutRequest.fromJson(response.data);
        update();
      } else {
        // showToast(message: response.message, isError: true);
        showErrorSheet(
          title: "Error",
          message: response.message,
        );
      }
    } catch (e) {
      // showToast(message: "Error loading payout details: ${e.toString()}", isError: true);
      showErrorSheet(
        title: "Error",
        message: "Error loading payout details: ${e.toString()}",
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Cancel payout request
  Future<void> cancelPayoutRequest(int payoutId) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.cancelPayoutRequest(payoutId);

      if (response.status == "success") {
        // showToast(message: "Payout request cancelled successfully", isError: false);

        // Refresh data
        getPayoutHistory();
        refreshBalance();

        // Update selected payout if it's the same one
        if (selectedPayoutRequest?.id == payoutId) {
          await getPayoutRequestDetails(payoutId);
        }
        showSuccessSheet(
          title: "Payout Cancelled",
          message: "Payout request cancelled successfully.",
        );
      } else {
        // showToast(message: response.message, isError: true);
        showErrorSheet(
          title: "Cancellation Failed",
          message: response.message,
        );
      }
    } catch (e) {
      // showToast(message: "Error cancelling payout request: ${e.toString()}", isError: true);
      showErrorSheet(
        title: "Error",
        message: "Error cancelling payout request: ${e.toString()}",
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await getPayoutHistory();
    await refreshBalance();
  }

  // Validate amount input
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = stripCurrencyFormat(value);
    if (amount <= 0) {
      return 'Please enter a valid amount';
    }

    if (amount < minimumPayoutAmount) {
      return 'Minimum amount is ${formatToCurrency(minimumPayoutAmount)}';
    }

    if (amount > maximumPayoutAmount) {
      return 'Maximum amount is ${formatToCurrency(maximumPayoutAmount)}';
    }

    if (amount > availableBalance) {
      return 'Insufficient balance';
    }

    return null;
  }

  // Clear form
  void clearForm() {
    amountController.clear();
    selectedPaymentMethod = 'bank';
    update();
  }

  // Get payout status color
  Color getPayoutStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.amberColor;
      case 'approved':
        return AppColors.blueColor;
      case 'processed':
        return AppColors.primaryColor;
      case 'completed':
        return AppColors.forestGreenColor;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }
}
