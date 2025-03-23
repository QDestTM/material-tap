import 'package:material_tap/enums/resource_path_side.dart';
import 'package:material_tap/widgets/resource_display.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';


class ResourceSender extends StatefulWidget
{
	static const double defaultSize = 86.0;

	// # ----------------------------------------------------------------------------------------------------<

	final void Function(ResourceData data) onResource;

	final ResourcePathSide side;
	final double size;

	const ResourceSender({
		super.key,
		this.size = defaultSize,

		required this.side,
		required this.onResource
	});

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceSender> createState() => ResourceSenderState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceSenderState extends State<ResourceSender>
{
	// Maps for alignments based on side
	static const startAlignmentMap = <ResourcePathSide, Alignment>
	{
		ResourcePathSide.up    : Alignment.bottomCenter,
		ResourcePathSide.right : Alignment.centerLeft  ,
		ResourcePathSide.left  : Alignment.centerRight ,
	};

	static const endAlignmentMap = <ResourcePathSide, Alignment>
	{
		ResourcePathSide.up    : Alignment.topCenter  ,
		ResourcePathSide.right : Alignment.centerRight,
		ResourcePathSide.left  : Alignment.centerLeft ,
	};

	// ^ ----------------------------------------------------------------------------------------------------<

	late AnimatedAlign? _sendedItem;
	late AnimatedAlign _pendingItem;


	Alignment get startAlignment
		=> startAlignmentMap[widget.side]!;

	Alignment get endAlignment
		=> endAlignmentMap[widget.side]!;

	bool get hasSended => _sendedItem != null;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Initializing items instances
		_pendingItem = createItem();
		_sendedItem = null;
	}

	// @ ----------------------------------------------------------------------------------------------------<

	void send(ResourceData data)
	{
		setState(() {
			_sendedItem = createItem(
				data: data,

				key: _pendingItem.key,
				alignment: endAlignment,
			);

			_pendingItem = createItem();
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	AnimatedAlign createItem({
		Alignment? alignment, Key? key, ResourceData? data })
	{
		// Fixing possible null reference data
		final fixedData = data ?? Icons.dangerous;

		// Building tree of widgets
		return AnimatedAlign(
			key: key ?? UniqueKey(),

			duration: const Duration(milliseconds: 800),
			alignment: alignment ?? startAlignment,

			onEnd: ()
			{
				setState(() {
					_sendedItem = null;
				});

				widget.onResource(fixedData);
			},

			child: ResourceDisplay(data: fixedData),
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Creating list of widgets for stack
		late final List<AnimatedAlign> children;

		if ( _sendedItem != null ) {
			children = [_pendingItem, _sendedItem!];
		} else {
			children = [_pendingItem];
		}

		// Building tree of widgets
		return ColoredBox(
			color: scheme.secondaryFixedDim,

			child: ConstrainedBox(
				constraints: widget.side == ResourcePathSide.up
					? BoxConstraints.tightFor(width: widget.size)
					: BoxConstraints.tightFor(height: widget.size),

				child: Stack(
					children: children
				),
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}