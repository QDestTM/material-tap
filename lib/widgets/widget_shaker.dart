import 'dart:math';

import 'package:flutter/material.dart';


class WidgetShaker extends StatefulWidget
{
	static const Cubic defaultCurve = Curves.easeOutQuart;

	static const double defaultFrequency = 8;
	static const double defaultScale = 4;

	// ^ ----------------------------------------------------------------------------------------------------<

	final double frequency;
	final double scale;
	final Cubic curve;

	final Widget? child;

	const WidgetShaker({
		super.key,

		this.frequency = defaultFrequency,
		this.scale = defaultScale,
		this.curve = defaultCurve,

		this.child
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<WidgetShaker> createState() => WidgetShakerState();

	// ------------------------------------------------------------------------------------------------------<
}


class WidgetShakerState extends State<WidgetShaker>
	with SingleTickerProviderStateMixin
{
	// ^ ----------------------------------------------------------------------------------------------------<

	late AnimationController _controller;

	bool _shakeX = false;
	bool _shakeY = false;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Initializing animation controller
		_controller = AnimationController(
			vsync: this, duration: const Duration(milliseconds: 800)
		);
	}


	@override
	void dispose()
	{
		_controller.dispose();
		super.dispose();
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void shakeX()
	{
		_shakeX = true;
		_shakeY = false;

		_controller.forward(from: 0.0);
	}


	void shakeY()
	{
		_shakeX = false;
		_shakeY = true;

		_controller.forward(from: 0.0);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedBuilder(
			animation: _controller,

			builder: (context, child)
			{
				final x = widget.curve.transform(_controller.value);
				final v = sin(x * pi * widget.frequency) * widget.scale;

				// Finding dx and dy
				final dx = !_shakeX ? 0.0 : v;
				final dy = !_shakeY ? 0.0 : v;

				// Building tree of widgets
				return Transform.translate(
					offset: Offset(dx, dy), child: child
				);
			},

			child: widget.child,
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}