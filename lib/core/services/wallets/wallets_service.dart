import 'package:gorider/core/utils/exports.dart';

class WalletsService extends CoreService {
  Future<WalletsService> init() async => this;

  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
        "/riders/transactions?page=${data['page']}&per_page=${data['per_page']}");
  }

  Future<APIResponse> getSingleTransaction(dynamic data) async {
    return await fetch("/riders/transactions/${data['id']}");
  }

  Future<APIResponse> getWalletBalance() async {
    return await fetch("/riders/wallet");
  }

  Future<APIResponse> fundWallet(dynamic data) async {
    return await send("/riders/wallet/fund", data);
  }

  Future<APIResponse> getBankList() async {
    return await fetch("/banks/list");
  }

  Future<APIResponse> verifyPayoutBank(dynamic data) async {
    return await send("/banks/verify-account", data);
  }

  Future<APIResponse> updatePayoutAccount(dynamic data) async {
    return await send("/riders/payout-account", data);
  }

  Future<APIResponse> getPayoutBankAccount() async {
    return await fetch("/riders/payout-account");
  }
}
