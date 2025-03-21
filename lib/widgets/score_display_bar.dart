import 'package:flutter/material.dart';


class ScoreDisplayBar extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	const ScoreDisplayBar({super.key});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ScoreDisplayBar> createState() => ScoreDisplayBarState();

	// ------------------------------------------------------------------------------------------------------<
}


class ScoreDisplayBarState extends State<ScoreDisplayBar>
{
	// ^ ----------------------------------------------------------------------------------------------------<

	int _scoreValue = 0;

	// # ----------------------------------------------------------------------------------------------------<

	void update(int value)
	{
		setState(() {
			_scoreValue = value;
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		return Padding(
			padding: const EdgeInsets.only(top: 24.0),

			child: Center(
				child: TweenAnimationBuilder(
					tween: IntTween(begin: 0, end: _scoreValue),

					duration: const Duration(milliseconds: 800),
					curve: Curves.easeInOutQuart,

					builder: (_, int value, _)
					{
						return Text(
							"$value",

							style: TextStyle(
								fontSize: 34,
								fontWeight: FontWeight.bold,

								fontFamily: "Monospace",

								shadows: const <BoxShadow>
								[
									BoxShadow(
										color: Color.fromARGB(148, 0, 0, 0),
										blurRadius: 3, offset: Offset(0, 2)
									)
								]
							),
						);
					},
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}