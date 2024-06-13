import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer_app/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const _duration = 60;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc(this._ticker) : super(const TimerInitial(_duration)) {
    on<TimeStarted>(_onTimerStarted);
    on<_TimerTicked>(_onTimerTicked);
    on<TimerReset>(_onTimerReset);
    on<TimerResumed>(_onTimerResumed);
    on<TimerPaused>(_onTimerPaused);
  }

  /// override this method to cancel the subscription when this bloc is no longer used
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onTimerStarted(TimeStarted event, Emitter<TimerState> emit) {
    // push state wuth start duration
    emit(TimerRunInProgress(event.duration));
    // if subscription was alread open to the stream , close it
    _tickerSubscription?.cancel();
    // generate ticker based on duration
    // the listen to the ticker(stream<int>) and notify the ui on every tick by adding _timerticked event
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onTimerTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerRunInProgress(event.duration)
        : const TimerRunComplete());
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  void _onTimerPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onTimerResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }
}
