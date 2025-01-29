import 'package:go_logistics_driver/models/bank_account_model.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class WalletController extends GetxController {
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

  final withdrawFromWalletFormKey = GlobalKey<FormState>();
  TextEditingController amountEntryController = TextEditingController();
  withdrawFromWallet() async {
    if (withdrawFromWalletFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'amount': stripCurrencyFormat(amountEntryController.text),
      };
      APIResponse response = await walletService.withdrawFromWallet(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        amountEntryController.clear();
        getWalletBalance();
        update();
      }
    }
  }

  bool walletBalanceVisibility = false;
  GetStorage getStorage = GetStorage();
  toggleWalletBalanceVisibility() {
    walletBalanceVisibility = !walletBalanceVisibility;
    getStorage.write("walletBalanceVisibility", walletBalanceVisibility);
    update();
  }

  List<BankModel> originalBanks = [];
  List<BankModel> filteredBanks = [];
  TextEditingController banksFilterController = TextEditingController();
  filterBanks(String query) {
    if (originalBanks.isNotEmpty && query.isNotEmpty) {
      filteredBanks = originalBanks
          .where((element) =>
              (element.name.toLowerCase().contains(query.toLowerCase()) ||
                  element.name.toLowerCase().contains(query.toLowerCase()) ||
                  element.name.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } else {
      filteredBanks = originalBanks;
    }
    update();
  }

  bool isLoadingBanks = false;
  getBankList() async {
    isLoadingBanks = true;
    update();
    APIResponse response = await walletService.getBankList();
    isLoadingBanks = false;
    update();
    if (response.status == "success") {
      originalBanks =
          (response.data as List).map((bk) => BankModel.fromJson(bk)).toList();
      filteredBanks = originalBanks;
      update();
    }
  }

  clearWithdrawalFields() {
    amountEntryController.clear();
    update();
  }

  BankModel? selectedBank;
  setSelectedBank(BankModel bank) async {
    selectedBank = bank;
    bankNameController.setText(bank.name);
    update();
    if (accountNumberController.text.length == 10) {
      await verifyPayoutBank();
    }
  }

  final payoutAccountFormKey = GlobalKey<FormState>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  bool verifyingAccountNumber = false;
  verifyPayoutBank() async {
    if (selectedBank != null) {
      verifyingAccountNumber = true;
      update();
      dynamic data = {
        'account_number': accountNumberController.text,
        'bank_code': selectedBank!.code,
      };
      print(data.toString());
      APIResponse response = await walletService.verifyPayoutBank(data);
      verifyingAccountNumber = false;
      update();
      if (response.status == "success") {
        resolvedBankAccountName.text = response.data['account_name'];
        update();
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  BankAccount? payoutBankAccount;
  bool isFetchingBankAccount = false;
  getPayoutBankAccount() async {
    isFetchingBankAccount = true;
    update();
    APIResponse response = await walletService.getPayoutBankAccount();
    isFetchingBankAccount = false;
    update();
    if (response.status == "success") {
      payoutBankAccount = BankAccount.fromJson(response.data);
      update();
    }
  }

  TextEditingController resolvedBankAccountName = TextEditingController();
  clearImputedBankFields() {
    resolvedBankAccountName.clear();
    bankNameController.clear();
    accountNumberController.clear();
    accountPasswordController.clear();
    selectedBank = null;
    update();
  }

  bool accountPasswordVisibility = false;

  toggleAccountPasswordVisibility() {
    accountPasswordVisibility = !accountPasswordVisibility;
    update();
  }

  TextEditingController accountPasswordController = TextEditingController();
  bool updatingBankAccount = false;
  updatePayoutAccount() async {
    if (payoutAccountFormKey.currentState!.validate()) {
      updatingBankAccount = true;
      update();
      dynamic data = {
        'bank_account_number': accountNumberController.text,
        'bank_code': selectedBank!.code,
        "password": accountPasswordController.text,
      };
      APIResponse response = await walletService.updatePayoutAccount(data);
      updatingBankAccount = false;
      update();
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        clearImputedBankFields();
        getPayoutBankAccount();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (getStorage.read("walletBalanceVisibility") == null) {
      getStorage.write("walletBalanceVisibility", false);
      walletBalanceVisibility = getStorage.read("walletBalanceVisibility");
    }
    update();
    getWalletBalance();
    getPayoutBankAccount();
    getAllTransactions();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Load wallet balance and transactions when the controller is initialized
  //   getWalletBalance();
  //   getAllTransactions();
  // }
}
