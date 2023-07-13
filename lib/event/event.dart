import 'package:replay_bloc/replay_bloc.dart';

class CounterEvent extends ReplayEvent {
  const CounterEvent();
}

class Increment extends CounterEvent {
  const Increment();
}

class Decrement extends CounterEvent {
  const Decrement();
}
