import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/ticker.dart';
import 'package:timer_app/timer/cubit/timer_cubit.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerCubit(const Ticker()),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<TimerCubit, TimerState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              final timeDuration = context.watch<TimerCubit>().state.duration;
              final minutesStr =
                  ((timeDuration / 60) % 60).floor().toString().padLeft(2, '0');
              final secondsStr =
                  (timeDuration % 60).floor().toString().padLeft(2, '0');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$minutesStr:$secondsStr',
                    style: const TextStyle(fontSize: 50),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ...switch (state) {
                      TimerInitial() => [
                          IconButton(
                            onPressed: () {
                              context.read<TimerCubit>().startTimer();
                            },
                            icon: const Icon(Icons.play_arrow),
                          )
                        ],
                      TimerRunPause() => [
                          IconButton(
                              onPressed: () {
                                context.read<TimerCubit>().resumerTimer();
                              },
                              icon: const Icon(Icons.play_arrow)),
                          IconButton(
                              onPressed: () {
                                context.read<TimerCubit>().resetTimer();
                              },
                              icon: const Icon(Icons.replay)),
                        ],
                      TimerRunInProgress() => [
                          IconButton(
                              onPressed: () {
                                context.read<TimerCubit>().pauseTimer();
                              },
                              icon: const Icon(Icons.pause)),
                          IconButton(
                              onPressed: () {
                                context.read<TimerCubit>().resetTimer();
                              },
                              icon: const Icon(Icons.replay)),
                        ],
                      TimerRunComplete() => [
                          IconButton(
                              onPressed: () {
                                context.read<TimerCubit>().startTimer();
                              },
                              icon: const Icon(Icons.play_arrow)),
                        ],
                    }
                  ])
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
