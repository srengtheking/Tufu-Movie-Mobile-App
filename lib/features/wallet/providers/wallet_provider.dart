import 'package:flutter/foundation.dart';

import '../../movies/data/movie.dart';

class CoinPack {
  final String id;
  final int coins;
  final int bonus;
  final String price;

  const CoinPack({
    required this.id,
    required this.coins,
    required this.bonus,
    required this.price,
  });

  int get total => coins + bonus;
}

class WalletTransaction {
  final String title;
  final int amount; // negative = spent, positive = top up

  const WalletTransaction({required this.title, required this.amount});
}

/// Local wallet state. Replace the mutations with API calls once the
/// payments backend is available.
class WalletProvider extends ChangeNotifier {
  static const packs = <CoinPack>[
    CoinPack(id: 'p100', coins: 100, bonus: 0, price: '\$0.99'),
    CoinPack(id: 'p300', coins: 300, bonus: 20, price: '\$2.99'),
    CoinPack(id: 'p500', coins: 500, bonus: 60, price: '\$4.99'),
    CoinPack(id: 'p1000', coins: 1000, bonus: 150, price: '\$9.99'),
  ];

  static const paymentMethods = ['ABA Pay', 'Credit / Debit card', 'KHQR'];

  int _balance = 100;
  final Set<String> _owned = {};
  final List<WalletTransaction> _history = [];

  int get balance => _balance;
  List<WalletTransaction> get history => List.unmodifiable(_history);

  bool owns(Movie movie) => movie.isFree || _owned.contains(movie.id);
  bool canAfford(Movie movie) => _balance >= movie.price;
  int missingFor(Movie movie) => (movie.price - _balance).clamp(0, movie.price);

  /// Returns false when the balance is too low.
  bool buy(Movie movie) {
    if (owns(movie)) return true;
    if (!canAfford(movie)) return false;
    _balance -= movie.price;
    _owned.add(movie.id);
    _history.insert(
      0,
      WalletTransaction(title: movie.title, amount: -movie.price),
    );
    notifyListeners();
    return true;
  }

  Future<void> topUp(CoinPack pack, String method) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _balance += pack.total;
    _history.insert(
      0,
      WalletTransaction(
        title: 'Top up · ${pack.coins} coins',
        amount: pack.total,
      ),
    );
    notifyListeners();
  }
}
