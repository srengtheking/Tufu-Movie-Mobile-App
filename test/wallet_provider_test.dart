import 'package:flutter_test/flutter_test.dart';
import 'package:tufu_movie/features/movies/data/sample_movies.dart';
import 'package:tufu_movie/features/wallet/providers/wallet_provider.dart';

void main() {
  test('buying deducts coins and unlocks the movie', () {
    final wallet = WalletProvider();
    final movie = SampleMovies.all.firstWhere(
      (m) => !m.isFree && m.price <= wallet.balance,
    );
    final before = wallet.balance;

    expect(wallet.owns(movie), isFalse);
    expect(wallet.buy(movie), isTrue);
    expect(wallet.owns(movie), isTrue);
    expect(wallet.balance, before - movie.price);
    expect(wallet.history.first.amount, -movie.price);
  });

  test('buying without enough coins fails and reports the shortfall', () {
    final wallet = WalletProvider();
    final movie = SampleMovies.all.firstWhere((m) => m.price > wallet.balance);

    expect(wallet.buy(movie), isFalse);
    expect(wallet.owns(movie), isFalse);
    expect(wallet.missingFor(movie), movie.price - wallet.balance);
  });

  test('free movies are always owned', () {
    final wallet = WalletProvider();
    final free = SampleMovies.all.firstWhere((m) => m.isFree);
    expect(wallet.owns(free), isTrue);
  });
}
