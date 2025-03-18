import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';


class ResourceSenderItem extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function(ResourceData data) checkResource;
	final void Function() removeItem;

	final Alignment displayAlignment;
	final ResourceData displayData;

	const ResourceSenderItem({
		required super.key,

		required this.displayAlignment,
		required this.displayData,

		required this.checkResource,
		required this.removeItem
	});

	// # ----------------------------------------------------------------------------------------------------<

	ResourceSenderItem sended(Alignment alignment, ResourceData data)
	{
		return ResourceSenderItem(
			key: key,

			displayAlignment: alignment,
			displayData: data,

			checkResource: checkResource,
			removeItem: removeItem
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedAlign(
			duration: const Duration(milliseconds: 800),
			curve: Curves.easeOutQuart,

			onEnd: () {
				checkResource(displayData); removeItem();
			},

			alignment: displayAlignment,
			child: ResourceDisplay(data: displayData),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
