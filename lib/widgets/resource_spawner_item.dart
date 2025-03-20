import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';


class ResourceSpawnerItem extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function()? onRemove;

	final ResourceData data;
	final double offset;
	final double size;

	const ResourceSpawnerItem({
		required super.key,

		required this.offset,
		required this.size,
		required this.data,

		this.onRemove
	});

	// # ----------------------------------------------------------------------------------------------------<

	ResourceSpawnerItem withOffset(double offset)
	{
		return ResourceSpawnerItem(
			key: key,

			size: size,
			data: data,

			onRemove: onRemove,
			offset: offset,
		);
	}


	ResourceSpawnerItem withRemoveCallback(
		void Function() onRemove, double offset)
	{
		return ResourceSpawnerItem(
			key: key,

			size: size,
			data: data,

			onRemove: onRemove,
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

			onEnd: onRemove,
			width: size,

			duration: const Duration(milliseconds: 800),
			curve: Curves.easeOutQuart,

			child: Center(
				child: ResourceDisplay(data: data)
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
