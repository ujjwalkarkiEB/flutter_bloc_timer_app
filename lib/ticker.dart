class Ticker {
  const Ticker();

  /// method that generates stream to mock timer
  /// * [ticks] : no. of counts
  /// Returns stream based on ticks count
  Stream<int> tick({required int ticks}) {
    // return stream that emits tick every seconds
    return Stream.periodic(
        const Duration(seconds: 1), (tick) => ticks - tick - 1).take(ticks);
  }
}
