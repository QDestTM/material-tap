import 'package:flutter/material.dart';
import 'package:material_tap/models/score_state.dart';
import 'package:provider/provider.dart';


class ScoreDisplay extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	const ScoreDisplay({super.key});

	// # ----------------------------------------------------------------------------------------------------<

	Widget tweenBuilder(BuildContext context, int value, Widget? _)
	{
		// Building tree of widgets
		return Text(
			value.toString(),

			style: const TextStyle(
				fontSize: 34,
				fontWeight: FontWeight.bold,

				fontFamily: "Monospace",

				shadows: <BoxShadow>
				[
					BoxShadow(
						color: Color.fromARGB(148, 0, 0, 0),
						blurRadius: 3, offset: Offset(0, 2)
					)
				]
			),
		);
	}


	Widget stateBuilder(BuildContext context, ScoreState state, Widget? _)
	{
		final score = state.get();

		// Building tree of widgets
		return Padding(
			padding: const EdgeInsets.only(top: 24.0),

			child: Center(
				child: TweenAnimationBuilder(
					tween: IntTween(begin: 0, end: score),
					builder: tweenBuilder,

					duration: const Duration(milliseconds: 800),
					curve: Curves.easeInOutQuart,
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return Consumer<ScoreState>(
			builder: stateBuilder
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
