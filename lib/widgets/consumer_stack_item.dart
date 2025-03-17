import 'package:material_tap/widgets/resource_slot.dart';

import 'package:material_tap/const.dart';
import 'package:flutter/material.dart';


class ConsumerStackItem extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final void Function(IconData resource) checkResource;
	final void Function() removeItem;

	final Alignment startAlignment;
	final Alignment endAlignment;

	const ConsumerStackItem({
		required super.key,

		required this.startAlignment,
		required this.endAlignment,

		required this.checkResource,
		required this.removeItem
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ConsumerStackItem> createState() => ConsumerStackItemState();

	// ------------------------------------------------------------------------------------------------------<
}

class ConsumerStackItemState extends State<ConsumerStackItem>
{
	// ^ ----------------------------------------------------------------------------------------------------<

	IconData _resource = Icons.dangerous;

	bool _sended = false;
	bool _remove = false;

	// # ----------------------------------------------------------------------------------------------------<

	void send(IconData resource)
	{
		setState(() {
			_resource = resource;
			_sended = true;
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onAlignAnimationEnd()
	{
		if ( !_sended ) return;

		// Call check resource callback
		widget.checkResource(_resource);

		// Start remove animation
		setState(() {
			_remove = true;
		});
	}


	void _onScaleAnimationEnd()
	{
		if ( !_remove ) return;
		widget.removeItem();
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return AnimatedAlign(
			duration: slotAnimationTime,
			curve: Curves.easeOutQuart,

			onEnd: _onAlignAnimationEnd,
			alignment: _sended
				? widget.endAlignment
				: widget.startAlignment,

			child: AnimatedScale(
				duration: slotAnimationTime,
				curve: Curves.easeOutQuart,

				scale: _remove ? 0.0 : 1.0,
				onEnd: _onScaleAnimationEnd,

				child: ResourceSlot(
					resource: _resource,
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}