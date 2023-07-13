// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'counter/bloc/counter_bloc.dart';
import 'counter/bloc/theme_bloc.dart';
import 'counter/theme/app_theme.dart';
// import 'counter_observer.dart';

Future<void> main() async {
  // Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CounterBloc()),
          BlocProvider(
              create: (context) =>
                  SwitchThemeBloc(initialTheme: AppTheme.lightTheme)),
        ],
        child: BlocBuilder<SwitchThemeBloc, bool>(builder: (context, state) {
          return MaterialApp(
            title: 'Flutter By Tan Khang Pham',
            theme: state ? AppTheme.darkTheme : AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(),
          );
        }));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const MyDemoPage(),
    );
  }
}

class MyDemoPage extends StatelessWidget {
  const MyDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloc>();
    final themeBloc = context.read<SwitchThemeBloc>();
    final Brightness brightness = Theme.of(context).brightness;
    bool isDark = themeBloc.isDark;

    Future<void> _updateSwitchState(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', value);
      isDark = value;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App Using Bloc"),
        // centerTitle: true,
        actions: [
          BlocConsumer<SwitchThemeBloc, bool>(
              listener: (context, state) {
                CherryToast.success(title: const Text("Theme changed"))
                    .show(context);
              },
              builder: (context, isDark) => SizedBox(
                    width: 150,
                    child: SwitchListTile(
                      title: const Text('Lights'),
                      value: isDark,
                      onChanged: (value) {
                        themeBloc.switchTheme();
                        (brightness == Brightness.dark)
                            ? isDark = true
                            : isDark = false;
                        _updateSwitchState(value);
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ),
                  )),
        ],
      ),
      body: BlocConsumer<CounterBloc, int>(
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("The value is alternative"),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: "undo",
                onPressed: () {
                  counterBloc.undo();
                },
              ),
            ));
          },
          builder: (context, count) => Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    child: TextButton(
                      onPressed: () {
                        counterBloc.decrement();
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.minus,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("$count",
                      style: const TextStyle(
                        fontSize: 60,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: TextButton(
                        onPressed: () {
                          counterBloc.increment();
                        },
                        child: const FaIcon(FontAwesomeIcons.plus,
                            size: 60, color: Colors.white)),
                  )
                ]),
              )),
    );
  }
}
