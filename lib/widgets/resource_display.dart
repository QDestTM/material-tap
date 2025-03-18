import 'package:material_tap/types.dart';
import 'package:flutter/material.dart';


/// A stateless widget that displays an icon representing a resource.
class ResourceDisplay extends StatelessWidget
{
	static const double defaultIconSize = defaultDispSize / 2.0;
	static const double defaultDispSize = 64.0;

	static const shadows = <BoxShadow>
	[
		BoxShadow(
			color: Color.fromARGB(124, 0, 0, 0),
			blurRadius: 3, spreadRadius: 2,
		),
	];

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
		return Container(
			width: dispSize,
			height: dispSize,

			decoration: BoxDecoration(
				color: scheme.primaryFixed,
				borderRadius: borderRadius,
				boxShadow: shadows
			),

			child: Icon(
				data, size: iconSize, shadows: shadows
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}