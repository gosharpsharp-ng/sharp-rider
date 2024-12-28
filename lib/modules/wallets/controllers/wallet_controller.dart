


import 'package:go_logistics_driver/utils/exports.dart';

class WalletController extends GetxController{
  final walletService = serviceLocator<WalletsService>();
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  List<Transaction> transactions = [];
  getAllTransactions() async {
    setLoadingState(true);
    APIResponse response = await walletService.getAllTransactions();
    setLoadingState(false);
    if (response.status == "success") {
      transactions = (response.data['data'] as List)
          .map((tr) => Transaction.fromJson(tr))
          .toList();
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  Transaction? selectedTransaction;
  setSelectedTransaction(Transaction tr) {
    selectedTransaction = tr;
    update();
  }

  getTransactionById() async {
    setLoadingState(true);
    dynamic data = {
      'id': selectedTransaction!.id,
    };
    APIResponse response = await walletService.getSingleTransaction(data);

    setLoadingState(false);
    if (response.status == "success") {
      selectedTransaction = Transaction.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  WalletBalanceDataModel? walletBalanceData;
  getWalletBalance() async {
    APIResponse response = await walletService.getWalletBalance();
    setLoadingState(false);
    if (response.status == "success") {
      walletBalanceData = WalletBalanceDataModel.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }



  final fundWalletFormKey = GlobalKey<FormState>();
  TextEditingController amountEntryController = TextEditingController();
  fundWallet() async {
    if (fundWalletFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'amount': stripCurrencyFormat(amountEntryController.text),
      };

      APIResponse response = await walletService.fundWallet(data);

      setLoadingState(false);
      if (response.status == "success") {

        amountEntryController.clear();
        update();
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  List<BankModel> banks = [];
  getBankList() async {
    setLoadingState(true);
    APIResponse response = await walletService.getBankList();
    showToast(message: response.message, isError: response.status != "success");
    setLoadingState(false);
    if (response.status == "success") {
      banks =
          (response.data as List).map((bk) => BankModel.fromJson(bk)).toList();
    }
  }

  clearFundingFields() {
    amountEntryController.clear();
    update();
  }

  final payoutAccountFormKey = GlobalKey<FormState>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  verifyPayoutBank() async {
    if (payoutAccountFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'account_number': accountNumberController.text,
        'bank_code': bankCodeController.text,
      };
      APIResponse response = await walletService.verifyPayoutBank(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {}
    }
  }

  TextEditingController otpController = TextEditingController();
  updatePayoutAccount() async {
    if (payoutAccountFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'bank_account_number': accountNumberController.text,
        'bank_code': bankCodeController.text,
        "otp": "1234",
      };
      APIResponse response = await walletService.updatePayoutAccount(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {}
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load wallet balance and transactions when the controller is initialized
    getWalletBalance();
    getAllTransactions();
  }
}