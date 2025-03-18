import 'package:material_tap/widgets/resource_display.dart';

import 'package:material_tap/types.dart';
import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';


class ResourceSpawnerItem extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function() itemRemove;

	final ResourceData data;
	final double offset;

	const ResourceSpawnerItem({
		required super.key,

		required this.offset,
		required this.data,

		required this.itemRemove,
	});

	// # ----------------------------------------------------------------------------------------------------<

	ResourceSpawnerItem withOffset(double offset)
	{
		return ResourceSpawnerItem(
			key: key, data: data,
			itemRemove: itemRemove,
			offset: offset,
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedPositioned(
			top: offset,

			width: resourceLineSize,
			onEnd: itemRemove,

			duration: const Duration(milliseconds: 800),
			curve: Curves.easeOutQuart,

			child: Center(
				child: ResourceDisplay(data: data)
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
