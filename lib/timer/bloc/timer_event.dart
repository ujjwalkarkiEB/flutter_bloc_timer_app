part of 'timer_bloc.dart';

sealed class TimerEvent {
  const TimerEvent();
}

// this event accepts duration as input
final class TimeStarted extends TimerEvent {
  final int duration;
  const TimeStarted(this.duration);
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

final class TimerReset extends TimerEvent {
  const TimerReset();
}

final class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final int duration;
}
