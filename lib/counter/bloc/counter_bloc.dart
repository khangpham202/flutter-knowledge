// ignore_for_file: invalid_use_of_visible_for_testing_member

// import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../../event/event.dart';
// ReplayBloc dùng để làm cái tính năng undo, redo

class CounterBloc extends ReplayBloc<CounterEvent, int> with HydratedMixin {
  CounterBloc() : super(0) {
    hydrate();
  }
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  Stream<int> mapEventToState(CounterEvent event) async* {
    yield state;
  }

  @override
  int fromJson(Map<String, dynamic> json) {
    return json['counter'] as int;
  }

  @override
  Map<String, int> toJson(int state) {
    return {'counter': state};
  }
}
