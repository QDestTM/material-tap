import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';


class ResourceSenderItem extends StatelessWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function(ResourceData data) onResource;
	final void Function() onRemove;

	final Alignment displayAlignment;
	final ResourceData displayData;

	const ResourceSenderItem({
		required super.key,

		required this.displayAlignment,
		required this.displayData,

		required this.onResource,
		required this.onRemove
	});

	// # ----------------------------------------------------------------------------------------------------<

	ResourceSenderItem sended(Alignment alignment, ResourceData data)
	{
		return ResourceSenderItem(
			key: key,

			displayAlignment: alignment,
			displayData: data,

			onResource: onResource,
			onRemove: onRemove
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedAlign(
			duration: const Duration(milliseconds: 800),
			curve: Curves.easeIn,

			onEnd: () {
				onResource(displayData); onRemove();
			},

			alignment: displayAlignment,
			child: ResourceDisplay(data: displayData),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}
