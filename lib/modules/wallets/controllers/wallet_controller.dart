import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/core/models/wallet_model.dart';

class WalletController extends GetxController {
  final walletService = serviceLocator<WalletsService>();
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  final ScrollController transactionsScrollController = ScrollController();
  bool fetchingTransactions = false;

  void _transactionsScrollListener() {
    if (transactionsScrollController.position.pixels >=
        transactionsScrollController.position.maxScrollExtent - 100) {
      getTransactions(isLoadMore: true);
    }
  }

  int transactionsPageSize = 15;
  int totalTransactions = 0;
  int currentTransactionsPage = 1;
  List<Transaction> transactions = [];

  setTotalTransactions(int val) {
    totalTransactions = val;
    update();
  }

  getTransactions({bool isLoadMore = false}) async {
    if (fetchingTransactions ||
        (isLoadMore && transactions.length >= totalTransactions)) return;

    fetchingTransactions = true;
    update();

    if (!isLoadMore) {
      transactions.clear(); // Clear only when not loading more
      currentTransactionsPage = 1;
    }

    dynamic data = {
      "page": currentTransactionsPage,
      "per_page": transactionsPageSize,
    };

    APIResponse response = await walletService.getAllTransactions(data);
    fetchingTransactions = false;

    if (response.status == "success") {
      List<Transaction> newTransactions = (response.data['data'] as List)
          .map((tr) => Transaction.fromJson(tr))
          .toList();

      if (isLoadMore) {
        transactions.addAll(newTransactions);
      } else {
        transactions = newTransactions;
      }

      setTotalTransactions(response.data['total']);
      currentTransactionsPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
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

  // Wallet data now comes from user profile, no separate endpoint
  Wallet? wallet;

  // Payout bank account
  BankAccount? payoutBankAccount;

  // Get wallet data from user profile (via SettingsController)
  void loadWalletFromProfile() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.userProfile?.wallet != null) {
          wallet = settingsController.userProfile!.wallet;
          update();
        }
      }
    } catch (e) {
      debugPrint("Error loading wallet from profile: $e");
    }
  }

  // Refresh wallet by fetching profile and syncing wallet data
  Future<void> refreshWalletFromProfile() async {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        await settingsController.getProfile();
        loadWalletFromProfile();
      }
    } catch (e) {
      debugPrint("Error refreshing wallet from profile: $e");
    }
  }

  // Get available balance as string (for backward compatibility)
  String get availableBalance => wallet?.balance ?? "0.00";

  // Get bonus balance as string
  String get bonusBalance => wallet?.bonusBalance ?? "0.00";

  // Get total balance (main + bonus)
  double get totalBalance => wallet?.totalBalance ?? 0.0;

  // Legacy method kept for compatibility - now loads from profile
  @Deprecated(
      'Use loadWalletFromProfile() instead. Wallet data is now in user profile.')
  getWalletBalance() async {
    loadWalletFromProfile();
  }

  bool walletBalanceVisibility = false;
  GetStorage getStorage = GetStorage();
  toggleWalletBalanceVisibility() {
    walletBalanceVisibility = !walletBalanceVisibility;
    getStorage.write("walletBalanceVisibility", walletBalanceVisibility);
    update();
  }

  PayStackAuthorizationModel? payStackAuthorizationData;

  final fundWalletFormKey = GlobalKey<FormState>();
  bool fundingWallet = false;
  TextEditingController amountEntryController = TextEditingController();
  fundWallet() async {
    if (fundWalletFormKey.currentState!.validate()) {
      fundingWallet = true;
      update();
      dynamic data = {
        'amount': stripCurrencyFormat(amountEntryController.text),
      };

      APIResponse response = await walletService.fundWallet(data);
      fundingWallet = false;
      update();
      if (response.status == "success") {
        payStackAuthorizationData =
            PayStackAuthorizationModel.fromJson(response.data);
        update();
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  clearFundingFields() {
    amountEntryController.clear();
    payStackAuthorizationData = null;
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
      originalBanks = (response.data['banks'] as List)
          .map((bk) => BankModel.fromJson(bk))
          .toList();
      filteredBanks = originalBanks;
      update();
    }
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
    if (selectedBank == null) {
      showToast(message: "Please select a bank first", isError: true);
      return;
    }

    if (accountNumberController.text.length != 10) {
      return;
    }

    verifyingAccountNumber = true;
    update();

    try {
      dynamic data = {
        'account_number': accountNumberController.text,
        'bank_code': selectedBank!.code,
      };
      APIResponse response = await walletService.verifyPayoutBank(data);

      if (response.status == "success") {
        resolvedBankAccountName.text = response.data['account_details']['account_name'];
        showToast(message: "Account verified successfully", isError: false);
        update();
      } else {
        resolvedBankAccountName.clear();
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      resolvedBankAccountName.clear();
      showToast(message: "Error verifying account: ${e.toString()}", isError: true);
    } finally {
      verifyingAccountNumber = false;
      update();
    }
  }

  TextEditingController resolvedBankAccountName = TextEditingController();
  clearImputedBankFields() {
    resolvedBankAccountName.clear();
    bankNameController.clear();
    accountNumberController.clear();
    selectedBank = null;
    update();
  }

  bool updatingBankAccount = false;
  updatePayoutAccount() async {
    if (!payoutAccountFormKey.currentState!.validate()) return;

    if (selectedBank == null) {
      showToast(message: "Please select a bank", isError: true);
      return;
    }

    if (resolvedBankAccountName.text.isEmpty) {
      showToast(message: "Please verify your account number first", isError: true);
      return;
    }

    updatingBankAccount = true;
    update();

    try {
      final data = {
        'bank_name': selectedBank!.name,
        'bank_code': selectedBank!.code,
        'bank_account_number': accountNumberController.text,
        'bank_account_name': resolvedBankAccountName.text,
      };

      APIResponse response = await walletService.updatePayoutAccount(data);

      if (response.status == "success") {
        showToast(message: "Bank account updated successfully", isError: false);
        await refreshBankAccountFromProfile(); // Refresh bank account data from profile
        filterBanks("");
        banksFilterController.clear();
        clearImputedBankFields();
        Get.back();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error updating bank account: ${e.toString()}", isError: true);
    } finally {
      updatingBankAccount = false;
      update();
    }
  }

  // Initialize bank account form with existing data
  void initializeBankAccountForm() {
    // Load existing bank account data if available
    if (payoutBankAccount != null) {
      bankNameController.text = payoutBankAccount!.bankName;
      accountNumberController.text = payoutBankAccount!.bankAccountNumber;
      resolvedBankAccountName.text = payoutBankAccount!.bankAccountName;

      // Try to find and set the selected bank
      if (originalBanks.isNotEmpty) {
        try {
          selectedBank = originalBanks.firstWhere(
            (bank) => bank.name == payoutBankAccount!.bankName,
          );
        } catch (e) {
          selectedBank = null;
        }
      }
    }
    update();
  }

  // Get payout bank account from user profile
  bool loadingPayoutBankAccount = false;

  // Load bank account from profile (via SettingsController)
  void loadBankAccountFromProfile() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.userProfile?.bankAccount != null) {
          payoutBankAccount = settingsController.userProfile!.bankAccount;
          update();
        }
      }
    } catch (e) {
      debugPrint("Error loading bank account from profile: $e");
    }
  }

  // Refresh bank account by fetching profile
  Future<void> refreshBankAccountFromProfile() async {
    loadingPayoutBankAccount = true;
    update();

    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        await settingsController.getProfile();
        loadBankAccountFromProfile();
      }
    } catch (e) {
      debugPrint("Error refreshing bank account from profile: $e");
    } finally {
      loadingPayoutBankAccount = false;
      update();
    }
  }

  // Legacy method - now loads from profile
  @Deprecated('Use loadBankAccountFromProfile() instead. Bank account is now in user profile.')
  getPayoutBankAccount() async {
    await refreshBankAccountFromProfile();
  }

  @override
  void onReady() {
    super.onReady();
    if (getStorage.read("walletBalanceVisibility") == null) {
      getStorage.write("walletBalanceVisibility", false);
      walletBalanceVisibility = getStorage.read("walletBalanceVisibility");
    }
    update();
    transactionsScrollController.addListener(_transactionsScrollListener);
    // Load wallet and bank account from profile instead of separate API calls
    loadWalletFromProfile();
    loadBankAccountFromProfile();
    getTransactions();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Load wallet balance and transactions when the controller is initialized
  //   getWalletBalance();
  //   getAllTransactions();
  // }
}
