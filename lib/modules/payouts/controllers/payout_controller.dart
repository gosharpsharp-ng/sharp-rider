import 'package:gorider/core/utils/exports.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final WalletsService _walletsService = serviceLocator<WalletsService>();

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmittingRequest = false;
  bool get isSubmittingRequest => _isSubmittingRequest;

  bool _fetchingPayouts = false;
  bool get fetchingPayouts => _fetchingPayouts;

  String _payoutError = '';
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
    getPayoutHistory();
    _loadBalanceFromWallet();
  }

  @override
  void onClose() {
    payoutHistoryScrollController.dispose();
    amountController.dispose();
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

  // Load balance from wallet controller
  void _loadBalanceFromWallet() {
    try {
      if (Get.isRegistered<WalletController>()) {
        final walletController = Get.find<WalletController>();
        availableBalance = double.tryParse(
                walletController.walletBalanceData?.availableBalance ?? '0') ??
            0.0;
        update();
      }
    } catch (e) {
      debugPrint("Error loading balance: $e");
    }
  }

  // Refresh balance (called after payout submission)
  Future<void> refreshBalance() async {
    if (Get.isRegistered<WalletController>()) {
      final walletController = Get.find<WalletController>();
      await walletController.getWalletBalance();
      _loadBalanceFromWallet();
    }
  }

  // Get payout history with pagination
  Future<void> getPayoutHistory({
    bool isLoadMore = false,
    String? status,
  }) async {
    if (_fetchingPayouts ||
        (isLoadMore && payoutRequests.length >= totalPayouts)) return;

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
        _payoutError = response.message ?? 'Failed to load payout history';
        showToast(message: _payoutError, isError: true);
      }
    } catch (e) {
      _fetchingPayouts = false;
      _payoutError = 'Error loading payout history: ${e.toString()}';
      showToast(message: _payoutError, isError: true);
      update();
    }
  }

  // Get single payout by ID
  Future<void> getPayoutById(int id) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.getPayoutById(id);

      if (response.status == "success" && response.data != null) {
        selectedPayoutRequest = PayoutRequest.fromJson(response.data);
        update();
      } else {
        showToast(
          message: response.message ?? 'Failed to load payout details',
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: 'Error loading payout details: ${e.toString()}',
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Submit payout request
  Future<bool> submitPayoutRequest() async {
    if (!payoutRequestFormKey.currentState!.validate()) {
      return false;
    }

    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;

    // Validate amount
    if (amount < minimumPayoutAmount) {
      showToast(
        message:
            'Minimum payout amount is ${formatToCurrency(minimumPayoutAmount)}',
        isError: true,
      );
      return false;
    }

    if (amount > maximumPayoutAmount) {
      showToast(
        message:
            'Maximum payout amount is ${formatToCurrency(maximumPayoutAmount)}',
        isError: true,
      );
      return false;
    }

    if (amount > availableBalance) {
      showToast(
        message: 'Insufficient balance. Available: ${formatToCurrency(availableBalance)}',
        isError: true,
      );
      return false;
    }

    setSubmittingState(true);

    try {
      final data = PayoutRequestData(
        amount: amount,
        paymentMethod: selectedPaymentMethod,
      ).toJson();

      final response = await _payoutService.submitPayoutRequest(data);

      if (response.status == "success") {
        showToast(
          message: 'Payout request submitted successfully',
          isError: false,
        );

        // Clear form
        amountController.clear();

        // Refresh data
        await refreshBalance();
        await getPayoutHistory();

        setSubmittingState(false);
        return true;
      } else {
        showToast(
          message: response.message ?? 'Failed to submit payout request',
          isError: true,
        );
        setSubmittingState(false);
        return false;
      }
    } catch (e) {
      showToast(
        message: 'Error submitting payout request: ${e.toString()}',
        isError: true,
      );
      setSubmittingState(false);
      return false;
    }
  }

  // Cancel payout request
  Future<void> cancelPayoutRequest(int id) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.cancelPayoutRequest(id);

      if (response.status == "success") {
        showToast(
          message: 'Payout request cancelled successfully',
          isError: false,
        );

        // Refresh payout history
        await getPayoutHistory();

        // Go back if on details screen
        if (Get.currentRoute.contains('payout-details')) {
          Get.back();
        }
      } else {
        showToast(
          message: response.message ?? 'Failed to cancel payout request',
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: 'Error cancelling payout request: ${e.toString()}',
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Validate amount
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null) {
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

  // Format currency helper
  String formatCurrency(double amount) {
    return formatToCurrency(amount);
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'processing':
      case 'approved':
        return Colors.blue;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
