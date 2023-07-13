// ignore_for_file: unrelated_type_equality_checks, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


/// Theme switching cubit.
class SwitchThemeBloc extends HydratedBloc<SwitchThemeBloc, bool> {
  /// Constructor.
  SwitchThemeBloc({required this.initialTheme}) : super(false);

  /// Initial theme will provide by schedulerBinding.
  final ThemeData initialTheme;
  bool isDark = false;
  @override
  bool fromJson(Map<String, dynamic> json) {
    return json['isDark'] as bool;
  }

  @override
  Map<String, dynamic> toJson(bool state) {
    return {'isDark': state};
  }

  /// Switches the theme
  void switchTheme() {
    state == false ? emit(true) : emit(false);
  }
}
