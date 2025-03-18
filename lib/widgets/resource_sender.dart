import 'package:material_tap/widgets/resource_sender_item.dart';
import 'package:material_tap/types.dart';

import 'package:flutter/material.dart';
import 'dart:collection';


class ResourceSender extends StatefulWidget
{
	static const double defaultSize = 86.0;

	// # ----------------------------------------------------------------------------------------------------<

	final AxisDirection direction;
	final double size;

	const ResourceSender({
		super.key,
		this.size = defaultSize,
		required this.direction
	});


	bool get isHorizontal =>
		direction == AxisDirection.left || direction == AxisDirection.right;

	bool get isVertical =>
		direction == AxisDirection.up || direction == AxisDirection.down;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	State<ResourceSender> createState() => ResourceSenderState();

	// ------------------------------------------------------------------------------------------------------<
}


class ResourceSenderState extends State<ResourceSender>
{
	// Maps for alignments based on direction
	static const startAlignmentMap = <AxisDirection, Alignment>
	{
		AxisDirection.up    : Alignment.bottomCenter,
		AxisDirection.right : Alignment.centerLeft  ,
		AxisDirection.down  : Alignment.topCenter   ,
		AxisDirection.left  : Alignment.centerRight ,
	};

	static const endAlignmentMap = <AxisDirection, Alignment>
	{
		AxisDirection.up    : Alignment.topCenter   ,
		AxisDirection.right : Alignment.centerRight ,
		AxisDirection.down  : Alignment.bottomCenter,
		AxisDirection.left  : Alignment.centerLeft  ,
	};

	// ^ ----------------------------------------------------------------------------------------------------<

	final _itemsQueue = Queue<ResourceSenderItem>();
	late ResourceSenderItem _pendingItem;

	Alignment get startAlignment
		=> startAlignmentMap[widget.direction]!;

	Alignment get endAlignment
		=> endAlignmentMap[widget.direction]!;

	// # ----------------------------------------------------------------------------------------------------<

	@override
	void initState()
	{
		super.initState();

		// Creating initial pending item
		_pendingItem = _createItem();
	}

	// ------------------------------------------------------------------------------------------------------<

	void send(ResourceData data)
	{
		setState(() {
			final sended = _pendingItem
				.sended(endAlignment, data);

			_itemsQueue.addLast(sended);
			_pendingItem = _createItem();
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	ResourceSenderItem _createItem()
	{
		// Building tree of widgets
		return ResourceSenderItem(
			key: UniqueKey(),

			displayAlignment: startAlignment,
			displayData: Icons.dangerous,

			checkResource: _onCheckResource,
			removeItem: _onRemoveItem,
		);
	}

	// ------------------------------------------------------------------------------------------------------<

	void _onCheckResource(ResourceData data)
	{
		// TODO: Implement this later.
	}


	void _onRemoveItem()
	{
		setState(() {
			_itemsQueue.removeFirst();
		});
	}

	// ------------------------------------------------------------------------------------------------------<

	@override
	Widget build(BuildContext context)
	{
		final scheme = Theme.of(context).colorScheme;

		// Building tree of widgets
		return Container(
			color: scheme.secondaryFixedDim,
			constraints: widget.isVertical
				? BoxConstraints.tightFor(width: widget.size)
				: BoxConstraints.tightFor(height: widget.size),

			child: Stack(
				children: <ResourceSenderItem>
				[
					_pendingItem,
					..._itemsQueue
				],
			),
		);
	}

	// ------------------------------------------------------------------------------------------------------<
}