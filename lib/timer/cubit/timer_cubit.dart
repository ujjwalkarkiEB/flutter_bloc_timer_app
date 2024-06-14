import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ticker.dart';
part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;
  TimerCubit(this._ticker) : super(const TimerInitial(_duration));

  StreamSubscription? _tickerSubscription;
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void startTimer() {
    _tickerSubscription?.cancel();

    emit(TimerRunInProgress(state.duration));
    _tickerSubscription = _ticker.tick(ticks: state.duration).listen((tick) {
      if (tick > 0) {
        emit(TimerRunInProgress(tick));
      } else {
        emit(const TimerRunComplete(_duration));
      }
    });
  }

  void pauseTimer() {
    _tickerSubscription?.pause();
    emit(TimerRunPause(state.duration));
  }

  void resumerTimer() {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void resetTimer() {
    emit(const TimerInitial(5));
    startTimer();
  }
}
