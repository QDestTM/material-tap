import 'package:material_tap/types.dart';
import 'package:flutter/material.dart';


/// A stateful widget that displays a resource icon with smooth animated transitions.
class ResourceSlot extends StatefulWidget
{
	static const double defaultSlotSize = 100.0;
	static const double defaultIconSize = 64.0;

	// ^ ----------------------------------------------------------------------------------------------------<

	final ResourceData data;

	final double slotSize;
	final double iconSize;

	const ResourceSlot({
		super.key,
		this.data = Icons.dangerous,
		this.slotSize = defaultSlotSize,
		this.iconSize = defaultIconSize
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceSlot> createState() => ResourceSlotState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceSlotState extends State<ResourceSlot>
{
	static const shadows = <BoxShadow>
	[
		BoxShadow(
			color: Color.fromARGB(124, 0, 0, 0),
			blurRadius: 3, spreadRadius: 2,
		)
	];

	static final borderRadius = BorderRadius.circular(32.0);

	// ^ ----------------------------------------------------------------------------------------------------<

	final _dataKey0 = UniqueKey();
	final _dataKey1 = UniqueKey();

	ResourceData _resourceData0 = Icons.dangerous;
	ResourceData _resourceData1 = Icons.dangerous;

	bool _switch = false; // false for 0, true for 1

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Setting initial resource
		_resourceData0 = widget.data;
	}

	// ------------------------------------------------------------------------------------------------------<

	ResourceData get()
	{
		return _switch ? _resourceData1 : _resourceData0;
	}


	void set(ResourceData data)
	{
		setState(() {
			_switch = !_switch;

			if ( _switch ) {
				_resourceData1 = data;
			} else {
				_resourceData0 = data;
			}
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Validate slot size and icon size
		assert(widget.slotSize > 0, "Slot size must be bigger than zero.");
		assert(widget.iconSize > 0, "Icon size must be bigger than zero.");

		// Building tree of the widgets
		return DecoratedBox(
			decoration: BoxDecoration(
				color: scheme.secondaryFixed,
				borderRadius: borderRadius,
				boxShadow: shadows
			),

			child: SizedBox(
				width: widget.slotSize,
				height: widget.slotSize,

				child: AnimatedSwitcher(
					duration: const Duration(milliseconds: 500),
					reverseDuration: const Duration(milliseconds: 0),

					switchInCurve: Curves.easeOutQuart,
					switchOutCurve: Curves.linear,

					transitionBuilder: (child, animation) => ScaleTransition(
						scale: animation, child: child
					),

					child: _switch
						? Icon(_resourceData1, key: _dataKey1,
							size: widget.iconSize, shadows: shadows)
						: Icon(_resourceData0, key: _dataKey0,
							size: widget.iconSize, shadows: shadows),
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}