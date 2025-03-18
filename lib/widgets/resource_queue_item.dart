import 'package:material_tap/widgets/resource_slot.dart';

import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';


class ResourceQueueItem extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function() removeItem;

	final IconData resource;
	final double offset;


	const ResourceQueueItem({
		required super.key,

		required this.offset,
		required this.resource,

		required this.removeItem,
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceQueueItem> createState() => ResourceQueueItemState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceQueueItemState extends State<ResourceQueueItem>
{
	// ^ ----------------------------------------------------------------------------------------------------<

	double _offset = 0.0;
	bool _remove = false;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Setting initial offset
		_offset = widget.offset;
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void offset(double value)
	{
		setState(() {
			_offset = value;
		});
	}


	void remove()
	{
		setState(() {
			_offset = -resourceSlotSize;
			_remove = true;
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onPositionedEnd()
	{
		if ( !_remove ) return;
		widget.removeItem();
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedPositioned(
			top: _offset,

			width: resourceLineSize,
			onEnd: _onPositionedEnd,

			duration: slotAnimationTime,
			curve: Curves.easeOutQuart,

			child: Center(
				child: ResourceSlot(
					resource: widget.resource
				),
			)
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}