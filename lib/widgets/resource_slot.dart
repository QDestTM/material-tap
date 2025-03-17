import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';


class ResourceSlot extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final IconData resource;

	const ResourceSlot({
		super.key,
		this.resource = Icons.dangerous,
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Container(
			width: resourceSlotSize,
			height: resourceSlotSize,

			decoration: BoxDecoration(
				color: scheme.primaryFixed,
				borderRadius: BorderRadius.circular(10.0),
				boxShadow: itemBaseShadows
			),

			child: Icon(resource,
				size: resourceSlotSize / 2,
				shadows: iconBaseShadows
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}