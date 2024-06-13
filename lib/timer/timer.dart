import 'package:flutter/material.dart';
import 'package:timer_app/ticker.dart';
import 'package:timer_app/timer/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(const Ticker()),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<TimerBloc, TimerState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              final timeDuration =
                  context.select((TimerBloc bloc) => bloc.state.duration);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...switch (state) {
                        TimerInitial() => [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<TimerBloc>()
                                    .add(TimeStarted(state.duration));
                              },
                              icon: const Icon(Icons.play_arrow),
                            )
                          ],
                        TimerRunPause() => [
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TimerBloc>()
                                      .add(const TimerResumed());
                                },
                                icon: const Icon(Icons.play_arrow)),
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TimerBloc>()
                                      .add(const TimerReset());
                                },
                                icon: const Icon(Icons.replay)),
                          ],
                        TimerRunInProgress() => [
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TimerBloc>()
                                      .add(const TimerPaused());
                                },
                                icon: const Icon(Icons.pause)),
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TimerBloc>()
                                      .add(const TimerReset());
                                },
                                icon: const Icon(Icons.replay)),
                          ],
                        TimerRunComplete() => [
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TimerBloc>()
                                      .add(TimeStarted(state.duration));
                                },
                                icon: const Icon(Icons.play_arrow)),
                          ]
                      },
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
