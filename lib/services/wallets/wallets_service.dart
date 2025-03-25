import 'package:go_logistics_driver/utils/exports.dart';

class WalletsService extends CoreService {
  Future<WalletsService> init() async => this;

  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
        "/me/transactions?page=${data['page']}&per_page=${data['per_page']}");
  }

  Future<APIResponse> getSingleTransaction(dynamic data) async {
    return await fetch("/me/transactions/${data['id']}");
  }

  Future<APIResponse> getWalletBalance() async {
    return await fetch("/me/wallet");
  }

  Future<APIResponse> withdrawFromWallet(dynamic data) async {
    return await send("/me/wallet/payout", data);
  }

  Future<APIResponse> getBankList() async {
    return await fetch("/bank-list");
  }

  Future<APIResponse> getPayoutBankAccount() async {
    return await fetch("/me/payout-account");
  }

  Future<APIResponse> verifyPayoutBank(dynamic data) async {
    return await send("/me/verify/payout-account", data);
  }

  Future<APIResponse> updatePayoutAccount(dynamic data) async {
    return await send("/me/payout-account", data);
  }
}
