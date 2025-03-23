import 'package:material_tap/widgets/resource_dock_frame.dart';
import 'package:material_tap/enums/resource_path_side.dart';
import 'package:material_tap/widgets/resource_slot.dart';
import 'package:material_tap/widgets/widget_shaker.dart';

import 'package:material_tap/types.dart';
import 'package:flutter/material.dart';


class ResourceDock extends StatefulWidget
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final ResourcePathSide side;
	final ResourceData data;

	const ResourceDock({
		super.key,
		required this.side,

		this.data = Icons.dangerous
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceDock> createState() => ResourceDockState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceDockState extends State<ResourceDock>
{
	// ^ ----------------------------------------------------------------------------------------------------<

	final _shaker = GlobalKey<WidgetShakerState>();
	final _slot = GlobalKey<ResourceSlotState>();

	// # ----------------------------------------------------------------------------------------------------<

	bool put(ResourceData data)
	{
		final requested = _slot.currentState!.get();

		// Checking provider resource
		final isValid = data == requested;

		if ( !isValid ) _shakeSlot();
		return isValid;
	}


	void set(ResourceData data)
	{
		_slot.currentState!.set(data);
	}


	ResourceData get()
	{
		return _slot.currentState?.get() ?? Icons.dangerous;
	}

	// ------------------------------------------------------------------------------------------------------<

	void _shakeSlot()
	{
		if ( widget.side == ResourcePathSide.up ) {
			_shaker.currentState?.shakeX();
		} else {
			_shaker.currentState?.shakeY();
		}
	}


	AxisDirection _getSideAsAxis()
	{
		switch (widget.side)
		{
			case ResourcePathSide.left:
				return AxisDirection.left;
			case ResourcePathSide.right:
				return AxisDirection.right;
			case ResourcePathSide.up:
				return AxisDirection.up;
		}
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		// Building tree of widgets
		return ResourceDockFrame(
			direction: _getSideAsAxis(),

			child: WidgetShaker(
				key: _shaker,

				child: ResourceSlot(
					key: _slot, data: widget.data
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}