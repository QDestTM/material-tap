import 'package:material_tap/types.dart';
import 'package:flutter/material.dart';


/// A stateless widget that displays an icon representing a resource.
class ResourceDisplay extends StatelessWidget
{
	static const double defaultIconSize = defaultDispSize / 1.5;
	static const double defaultDispSize = 64.0;

	static final borderRadius = BorderRadius.circular(10.0);

	// ^ ----------------------------------------------------------------------------------------------------<

	final ResourceData data;

	final double dispSize;
	final double iconSize;

	const ResourceDisplay({
		super.key,
		this.data = Icons.dangerous,
		this.dispSize = defaultDispSize,
		this.iconSize = defaultIconSize
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Validate display size and icon size
		assert(dispSize > 0, "Disp size must be bigger than zero.");
		assert(iconSize > 0, "Icon size must be bigger than zero.");

		// Building tree of the widgets
		return DecoratedBox(
			decoration: BoxDecoration(
				color: scheme.primaryFixed,
				borderRadius: borderRadius,

				boxShadow: const <BoxShadow>
				[
					BoxShadow(
						color: Color.fromARGB(124, 0, 0, 0),
						blurRadius: 3, spreadRadius: 2,
					),
				],
			),

			child: SizedBox.square(
				dimension: dispSize,

				child: Icon(
					data, size: iconSize,

					shadows: const <BoxShadow>
					[
						BoxShadow(
							color: Color.fromARGB(255, 0, 0, 0),
							blurRadius: 6, offset: Offset(1, 1)
						)
					]
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}