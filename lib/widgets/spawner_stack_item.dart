import 'package:material_tap/widgets/resource_slot.dart';

import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';


class SpawnerStackItem extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function(GlobalKey key) itemRemove;

	final IconData resource;
	final double offset;


	const SpawnerStackItem({
		required super.key,
		required this.itemRemove,
		required this.resource,
		required this.offset,
	});


	SpawnerStackItem.offset({
		required SpawnerStackItem source,
		required double offset
	}) : this(
		key: source.key,
		offset: offset,

		resource: source.resource,
		itemRemove: source.itemRemove
	);

	// # ----------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedPositioned(
			key: key,
			top: offset,

			width: resourceLineSize,
			onEnd: () => itemRemove(key as GlobalKey),

			duration: const Duration(milliseconds: 800),
			curve: Curves.easeOutQuart,

			child: Center(
				child: ResourceSlot(resource: resource),
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}