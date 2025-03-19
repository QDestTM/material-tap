import 'package:material_tap/const.dart';
import 'package:material_tap/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


void main()
{
	// Setting color of bottom bottom nav-bar for mobile devices
	final scheme = ColorScheme.fromSeed(seedColor: seedColor);

	SystemChrome.setSystemUIOverlayStyle(
		SystemUiOverlayStyle(
			systemNavigationBarColor: scheme.secondaryFixed
		),
	);

	// Initializing app widget
	final Widget app = const MaterialTap();

	// Starting app
	runApp(app);
}


class MaterialTap extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	const MaterialTap({super.key});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = ColorScheme.fromSeed(seedColor: seedColor);
		final theme = ThemeData(colorScheme: scheme);

		return MaterialApp(
			title: appTitle, theme: theme,
			debugShowCheckedModeBanner: false,

			home: const HomePage(),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
