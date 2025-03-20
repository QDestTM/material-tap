import 'package:flutter/material.dart';
import 'dart:math';


class ResourceDock extends StatelessWidget
{
	static const double defaultBodySize = 86.0;

	// Default border radius value for all maps
	static const borderRadius = Radius.circular(32.0);

	// Body border radius map
	static const bodyBorderRadiusMap = <AxisDirection, BorderRadius>
	{
		AxisDirection.up    : BorderRadius.vertical(bottom: borderRadius) ,
		AxisDirection.down  : BorderRadius.vertical(top: borderRadius)    ,
		AxisDirection.left  : BorderRadius.horizontal(right: borderRadius),
		AxisDirection.right : BorderRadius.horizontal(left: borderRadius) ,
	};

	// Decorations border radius map
	static const decoBorderRadiusMap = <AxisDirection, List<BorderRadius>>
	{
		AxisDirection.up    : [
			BorderRadius.only(bottomLeft: borderRadius),
			BorderRadius.only(bottomRight: borderRadius),
		],
		AxisDirection.down  : [
			BorderRadius.only(topRight: borderRadius),
			BorderRadius.only(topLeft: borderRadius),
		],
		AxisDirection.left  : [
			BorderRadius.only(bottomRight: borderRadius),
			BorderRadius.only(topRight: borderRadius),
		],
		AxisDirection.right : [
			BorderRadius.only(topLeft: borderRadius),
			BorderRadius.only(bottomLeft: borderRadius),
		],
	};

	// Alignment map for body and decorations
	static const bodyAlignmentMap = <AxisDirection, Alignment>
	{
		AxisDirection.up    : Alignment.topCenter   ,
		AxisDirection.down  : Alignment.bottomCenter,
		AxisDirection.left  : Alignment.centerLeft  ,
		AxisDirection.right : Alignment.centerRight ,
	};

	// Alignment map for decorations
	static const decoAlignmentMap = <AxisDirection, List<Alignment>>
	{
		AxisDirection.up    : [Alignment.topLeft, Alignment.topRight],
		AxisDirection.down  : [Alignment.bottomRight, Alignment.bottomLeft],
		AxisDirection.left  : [Alignment.bottomLeft, Alignment.topLeft],
		AxisDirection.right : [Alignment.topRight, Alignment.bottomRight],
	};

	// ^ ----------------------------------------------------------------------------------------------------<

	final AxisDirection direction;

	final double decoSizeMain; // "Height" of decoration
	final double decoSizeCros; // "Width" of decoration

	final double bodySize;
	final Widget? child;

	const ResourceDock({
		super.key,
		required this.direction,
		this.bodySize = defaultBodySize,

		this.decoSizeMain = defaultBodySize * 1.3,
		this.decoSizeCros = defaultBodySize * 0.3,

		this.child
	});


	double get crosSize => bodySize + (decoSizeCros * 2.0);
	double get mainSize => max(bodySize, decoSizeMain);

	// # ----------------------------------------------------------------------------------------------------<

	BoxConstraints _buildConstrains()
	{
		if ( direction == AxisDirection.left || direction == AxisDirection.right ) {
			return BoxConstraints.expand(width: mainSize, height: crosSize);
		} else {
			return BoxConstraints.expand(width: crosSize, height: mainSize);
		}
	}


	BoxConstraints _buildDecoConstrains()
	{
		if ( direction == AxisDirection.left || direction == AxisDirection.right ) {
			return BoxConstraints.expand(width: decoSizeMain, height: decoSizeCros);
		} else {
			return BoxConstraints.expand(width: decoSizeCros, height: decoSizeMain);
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	Align _buildBodyComponent(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Align(
			alignment: bodyAlignmentMap[direction]!,

			child: SizedBox.square(
				dimension: bodySize,

				child: DecoratedBox(
					decoration: BoxDecoration(
						color: scheme.secondaryFixed,
						borderRadius: bodyBorderRadiusMap[direction],

						boxShadow: const <BoxShadow>
						[
							BoxShadow(
								color: Color.fromARGB(124, 0, 0, 0),
								spreadRadius: 3, blurRadius: 2
							)
						],
					),

					child: Center(
						child: child
					),
				),
			),
		);
	}


	Align _buildDecorationComponent(BuildContext context, int index)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Align(
			alignment: decoAlignmentMap[direction]![index],

			child: ConstrainedBox(
				constraints: _buildDecoConstrains(),

				child: ClipRRect(
					borderRadius: decoBorderRadiusMap[direction]![index],

					child: ColoredBox(
						color: scheme.secondaryFixed
					),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return ConstrainedBox(
			constraints: _buildConstrains(),

			child: Stack(
				alignment: Alignment.center,
				fit: StackFit.expand,

				children: <Align>
				[
					_buildBodyComponent(context),

					_buildDecorationComponent(context, 0),
					_buildDecorationComponent(context, 1),
				],
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
